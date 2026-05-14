-- debug.lua
--
-- DAP setup: breakpoints, stepping, REPL, variable inspection, and Go test
-- debugging via delve. All bindings live under `<leader>d` (mac-friendly,
-- no function-key gymnastics).

return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
		"theHamsta/nvim-dap-virtual-text", -- inline variable values during a session
		"mason-org/mason.nvim",
		"jay-babu/mason-nvim-dap.nvim",
		"leoluz/nvim-dap-go",
	},
	keys = {
		-- Session control
		{
			"<leader>dc",
			function()
				require("dap").continue()
			end,
			desc = "Debug: [C]ontinue / Start",
		},
		{
			"<leader>dC",
			function()
				require("dap").run_to_cursor()
			end,
			desc = "Debug: Run to [C]ursor",
		},
		{
			"<leader>dl",
			function()
				require("dap").run_last()
			end,
			desc = "Debug: Run [L]ast",
		},
		{
			"<leader>dR",
			function()
				require("dap").restart()
			end,
			desc = "Debug: [R]estart",
		},
		{
			"<leader>dP",
			function()
				require("dap").pause()
			end,
			desc = "Debug: [P]ause",
		},
		{
			"<leader>dt",
			function()
				require("dap").terminate()
			end,
			desc = "Debug: [T]erminate",
		},

		-- Stepping
		{
			"<leader>ds",
			function()
				require("dap").step_over()
			end,
			desc = "Debug: [S]tep Over",
		},
		{
			"<leader>di",
			function()
				require("dap").step_into()
			end,
			desc = "Debug: Step [I]nto",
		},
		{
			"<leader>do",
			function()
				require("dap").step_out()
			end,
			desc = "Debug: Step [O]ut",
		},
		{
			"<leader>dj",
			function()
				require("dap").down()
			end,
			desc = "Debug: Frame Down",
		},
		{
			"<leader>dk",
			function()
				require("dap").up()
			end,
			desc = "Debug: Frame Up",
		},

		-- Breakpoints
		{
			"<leader>db",
			function()
				require("dap").toggle_breakpoint()
			end,
			desc = "Debug: Toggle [B]reakpoint",
		},
		{
			"<leader>dB",
			function()
				require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end,
			desc = "Debug: Conditional [B]reakpoint",
		},
		{
			"<leader>dp",
			function()
				require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
			end,
			desc = "Debug: Log[p]oint",
		},
		{
			"<leader>dX",
			function()
				require("dap").clear_breakpoints()
			end,
			desc = "Debug: Clear All Breakpoints",
		},

		-- Inspect
		{
			"<leader>dh",
			function()
				require("dap.ui.widgets").hover()
			end,
			desc = "Debug: [H]over Variable",
		},
		{
			"<leader>de",
			function()
				require("dapui").eval()
			end,
			desc = "Debug: [E]valuate",
			mode = { "n", "v" },
		},
		{
			"<leader>dF",
			function()
				local w = require("dap.ui.widgets")
				w.centered_float(w.frames)
			end,
			desc = "Debug: [F]rames Float",
		},
		{
			"<leader>dS",
			function()
				local w = require("dap.ui.widgets")
				w.centered_float(w.scopes)
			end,
			desc = "Debug: [S]copes Float",
		},

		-- Panels
		{
			"<leader>du",
			function()
				require("dapui").toggle()
			end,
			desc = "Debug: Toggle [U]I",
		},
		{
			"<leader>dr",
			function()
				require("dap").repl.toggle()
			end,
			desc = "Debug: Toggle [R]EPL",
		},

		-- Go-specific (via nvim-dap-go)
		{
			"<leader>dgt",
			function()
				require("dap-go").debug_test()
			end,
			desc = "Debug: Go Test Nearest",
		},
		{
			"<leader>dgl",
			function()
				require("dap-go").debug_last_test()
			end,
			desc = "Debug: Go Test Last",
		},
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		require("mason-nvim-dap").setup({
			automatic_installation = true,
			handlers = {},
			ensure_installed = {
				"delve",
			},
		})

		require("nvim-dap-virtual-text").setup({})

		dapui.setup({
			icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
			controls = {
				icons = {
					pause = "⏸",
					play = "▶",
					step_into = "⏎",
					step_over = "⏭",
					step_out = "⏮",
					step_back = "b",
					run_last = "▶▶",
					terminate = "⏹",
					disconnect = "⏏",
				},
			},
		})

		-- Breakpoint signs (nerd-font glyphs; fallback to ascii)
		vim.api.nvim_set_hl(0, "DapBreak", { fg = "#e51400" })
		vim.api.nvim_set_hl(0, "DapStop", { fg = "#ffcc00" })
		local breakpoint_icons = vim.g.have_nerd_font
				and { Breakpoint = "", BreakpointCondition = "", BreakpointRejected = "", LogPoint = "", Stopped = "" }
			or {
				Breakpoint = "●",
				BreakpointCondition = "⊜",
				BreakpointRejected = "⊘",
				LogPoint = "◆",
				Stopped = "⭔",
			}
		for type, icon in pairs(breakpoint_icons) do
			local tp = "Dap" .. type
			local hl = (type == "Stopped") and "DapStop" or "DapBreak"
			vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
		end

		-- Auto-open DAP UI when a session starts, but skip it for Dart/Flutter
		-- — `:FlutterRun` starts a DAP session for hot reload purposes, and the
		-- full UI is overkill for a normal run. Use <leader>du to open it
		-- manually when you actually want to debug a Flutter app.
		local function should_auto_open_ui()
			local session = dap.session()
			return session and session.config and session.config.type ~= "dart"
		end
		dap.listeners.after.event_initialized["dapui_config"] = function()
			if should_auto_open_ui() then
				dapui.open()
			end
		end
		dap.listeners.before.event_terminated["dapui_config"] = function()
			if should_auto_open_ui() then
				dapui.close()
			end
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			if should_auto_open_ui() then
				dapui.close()
			end
		end

		require("dap-go").setup({
			delve = {
				detached = vim.fn.has("win32") == 0,
			},
		})
	end,
}
