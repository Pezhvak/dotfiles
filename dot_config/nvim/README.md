# Pezhvak Neovim Config

Modular Neovim configuration based on `lazy.nvim`.

## Layout

- `init.lua`: entrypoint.
- `lua/pezhvak/core/`: options, keymaps, globals, autocommands.
- `lua/pezhvak/plugins/`: plugin specs (one plugin or related group per file).
- `lua/pezhvak/disabled-plugins/`: parked experiments.
- `lazy-lock.json`: pinned plugin versions.

## Usage

- Start Neovim: `nvim`
- Sync plugins: `:Lazy sync`
- Health check: `:checkhealth pezhvak`

## Development

- Format: `stylua .`
- Check format: `stylua --check .`

## Notes

- This repo assumes Nerd Font support (`vim.g.have_nerd_font = true`).
- LSP tooling is managed through Mason (`:Mason`).
