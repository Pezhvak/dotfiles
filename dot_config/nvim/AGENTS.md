# Repository Guidelines

## Project Structure & Module Organization
This repository is a modular Neovim configuration. Root `init.lua` loads `lua/pezhvak/`, where `core/` contains editor defaults (`options.lua`, `keymaps.lua`, `autocommands.lua`, `global.lua`) and `plugin-manager.lua` bootstraps `lazy.nvim`. Add plugin specs under `lua/pezhvak/plugins/`; keep one plugin or closely related plugin group per file, using names like `telescope.lua` or `nvim-lspconfig.lua`. Park experiments in `lua/pezhvak/disabled-plugins/`. `lazy-lock.json` records plugin versions.

## Build, Test, and Development Commands
- `nvim`: start the config locally and let `lazy.nvim` install or load plugins.
- `stylua .`: format all Lua files with the repo rules.
- `stylua --check .`: run the same formatting check as CI.
- `:Lazy sync`: refresh plugins after changing files in `lua/pezhvak/plugins/`.
- `:checkhealth pezhvak`: verify Neovim version and required executables such as `git`, `make`, `unzip`, and `rg`.

## Coding Style & Naming Conventions
Lua is formatted by Stylua using 2-space indentation, Unix line endings, single-quote preference, and a 160-column width; see `.stylua.toml`. Keep modules lowercase and require them with the `pezhvak.*` namespace. Prefer small, focused files and straightforward tables returned from plugin specs. Add comments only where intent is not obvious from the code.

## Testing Guidelines
There is no tracked unit-test suite for the config itself. Treat formatting and startup health as the baseline checks: run `stylua --check .`, then open `nvim` and confirm `:checkhealth pezhvak` is clean for the tools you use. `lua/pezhvak/plugins/test.lua` configures `vim-test` for projects edited inside Neovim; it is not a repository test harness.

## Commit & Pull Request Guidelines
This workspace snapshot does not include `.git`, so local history is unavailable. Use short, imperative commit subjects with a clear scope, for example `plugins: add harpoon keymaps` or `core: tighten option defaults`. Keep pull requests focused, describe behavior changes, list new dependencies, and include screenshots or terminal output when UI, diagnostics, or keymap workflows change. If contributing from a fork, verify the PR base repository before opening it.
