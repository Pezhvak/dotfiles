-- Flutter / Dart development.
--
-- flutter-tools.nvim wraps the Dart LSP (`dartls`) bundled with the Flutter
-- SDK and adds hot reload, device/emulator pickers, DevTools, and DAP wiring.
-- All bindings live under `<leader>F` to avoid colliding with `<leader>f`
-- (format) and the Go debug group.

return {
	"nvim-flutter/flutter-tools.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"stevearc/dressing.nvim", -- nicer ui.select for device/emulator pickers
	},
	ft = { "dart" },
	keys = {
		{ "<leader>Fr", "<cmd>FlutterRun<cr>", desc = "Flutter: [R]un" },
		{ "<leader>FR", "<cmd>FlutterRestart<cr>", desc = "Flutter: Hot [R]estart" },
		{ "<leader>Fh", "<cmd>FlutterReload<cr>", desc = "Flutter: [H]ot Reload" },
		{ "<leader>Fq", "<cmd>FlutterQuit<cr>", desc = "Flutter: [Q]uit" },
		{ "<leader>Fd", "<cmd>FlutterDevices<cr>", desc = "Flutter: [D]evices" },
		{ "<leader>Fe", "<cmd>FlutterEmulators<cr>", desc = "Flutter: [E]mulators" },
		{ "<leader>Fo", "<cmd>FlutterOutlineToggle<cr>", desc = "Flutter: [O]utline" },
		{ "<leader>Ft", "<cmd>FlutterDevTools<cr>", desc = "Flutter: Dev[T]ools" },
		{ "<leader>Fl", "<cmd>FlutterLogToggle<cr>", desc = "Flutter: [L]og Toggle" },
		{ "<leader>Fc", "<cmd>FlutterLogClear<cr>", desc = "Flutter: Log [C]lear" },
		{ "<leader>Fp", "<cmd>FlutterPubGet<cr>", desc = "Flutter: [P]ub Get" },
		{ "<leader>FP", "<cmd>FlutterPubUpgrade<cr>", desc = "Flutter: [P]ub Upgrade" },
	},
	config = function()
		-- Neovim 0.12+: enable document color highlights as inline virtual text.
		-- Auto-attaches to any LSP advertising the documentColor capability
		-- (dartls does); no-op for clients that don't.
		if vim.lsp.document_color and vim.lsp.document_color.enable then
			vim.lsp.document_color.enable(true, nil, { style = "virtual" })
		end

		require("flutter-tools").setup({
			ui = { border = "rounded", notification_style = "native" },
			decorations = {
				statusline = { app_version = true, device = true, project_config = true },
			},
			widget_guides = { enabled = true },
			closing_tags = { enabled = true, prefix = "// " },
			-- Do NOT auto-open the log on :FlutterRun. Summon it on demand
			-- with <leader>Fl. When opened, it lands as a small bottom split.
			dev_log = { enabled = false, open_cmd = "belowright 15split" },
			dev_tools = { autostart = false, auto_open_browser = false },
			outline = { open_cmd = "30vnew" },
			fvm = true, -- auto-detect .fvm and use project-pinned Flutter SDK
			lsp = {
				-- Document colors are handled by Neovim's built-in
				-- vim.lsp.document_color (enabled below, after setup).
				capabilities = require("blink.cmp").get_lsp_capabilities(),
				settings = {
					showTodos = true,
					completeFunctionCalls = true,
					renameFilesWithClasses = "prompt",
					enableSnippets = true,
					updateImportsOnRename = true,
					-- Skip vendored deps; do NOT exclude the Flutter SDK directory
					-- itself — projects living under it would be skipped too.
					analysisExcludedFolders = {
						vim.fn.expand("$HOME/.pub-cache"),
					},
				},
			},
			debugger = {
				enabled = true,
				-- Provide a default `dart` launch config so <leader>dc works in
				-- a Flutter project without a .vscode/launch.json. nvim-dap now
				-- reads launch.json automatically via its providers system, so
				-- no explicit load_launchjs call is needed.
				register_configurations = function(_)
					local dap = require("dap")
					if not dap.configurations.dart or #dap.configurations.dart == 0 then
						dap.configurations.dart = {
							{
								type = "dart",
								request = "launch",
								name = "Launch Flutter App",
								program = "${workspaceFolder}/lib/main.dart",
								cwd = "${workspaceFolder}",
							},
						}
					end
				end,
			},
		})
	end,
}
