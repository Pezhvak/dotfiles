return {

	{ -- Linting
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lint = require("lint")
			local yamllint_config_names = { ".yamllint", ".yamllint.yaml", ".yamllint.yml" }

			local function yamllint_args()
				local bufname = vim.api.nvim_buf_get_name(0)
				local dirname = vim.fs.dirname(bufname)
				local project_config = dirname
					and vim.fs.find(yamllint_config_names, {
						path = dirname,
						upward = true,
						stop = vim.env.HOME,
					})[1]

				if project_config then
					return { "--format", "parsable", "-c", project_config, "-" }
				end

				return {
					"--format",
					"parsable",
					"-c",
					vim.fn.stdpath("config") .. "/.yamllint",
					"-",
				}
			end

			local original_yamllint = lint.linters.yamllint
			lint.linters.yamllint = function()
				local yamllint = type(original_yamllint) == "function" and original_yamllint()
					or vim.deepcopy(original_yamllint)
				yamllint.args = yamllint_args()
				return yamllint
			end

			lint.linters_by_ft = {
				markdown = { "markdownlint" },
				yaml = { "yamllint" },
				go = { "golangcilint" },
			}

			-- To allow other plugins to add linters to require('lint').linters_by_ft,
			-- instead set linters_by_ft like this:
			-- lint.linters_by_ft = lint.linters_by_ft or {}
			-- lint.linters_by_ft['markdown'] = { 'markdownlint' }
			--
			-- However, note that this will enable a set of default linters,
			-- which will cause errors unless these tools are available:
			-- {
			--   clojure = { "clj-kondo" },
			--   dockerfile = { "hadolint" },
			--   inko = { "inko" },
			--   janet = { "janet" },
			--   json = { "jsonlint" },
			--   markdown = { "vale" },
			--   rst = { "vale" },
			--   ruby = { "ruby" },
			--   terraform = { "tflint" },
			--   text = { "vale" }
			-- }
			--
			-- You can disable the default linters by setting their filetypes to nil:
			-- lint.linters_by_ft['clojure'] = nil
			-- lint.linters_by_ft['dockerfile'] = nil
			-- lint.linters_by_ft['inko'] = nil
			-- lint.linters_by_ft['janet'] = nil
			-- lint.linters_by_ft['json'] = nil
			-- lint.linters_by_ft['markdown'] = nil
			-- lint.linters_by_ft['rst'] = nil
			-- lint.linters_by_ft['ruby'] = nil
			-- lint.linters_by_ft['terraform'] = nil
			-- lint.linters_by_ft['text'] = nil

			-- Create autocommand which carries out the actual linting
			-- on the specified events.
			local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = lint_augroup,
				callback = function()
					-- Only run the linter in buffers that you can modify in order to
					-- avoid superfluous noise, notably within the handy LSP pop-ups that
					-- describe the hovered symbol using Markdown.
					if vim.bo.modifiable then
						lint.try_lint()
					end
				end,
			})
		end,
	},
}
