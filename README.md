# Pezhvak Dotfiles

![Pezhvak Dotfiles Banner](assets/banner.svg)

> Personal dotfiles managed with `chezmoi`, tuned for a fast, modular, nerd-font-powered Neovim workflow.

## Why this repo exists

I want my terminal and editor to feel like a spaceship cockpit, not a text box.
This repo tracks my daily-driver setup in a reproducible way so I can bootstrap a new machine quickly and keep everything versioned.

## What is inside

- `chezmoi`-managed source tree (`dot_*` files map to real dotfiles on apply)
- A modular Neovim config under `dot_config/nvim/`
- Plugin loading with `lazy.nvim` (`lua/pezhvak/plugins/*.lua`)
- Opinionated keymaps, UI tweaks, and LSP tooling via Mason
- Nerd Font-first experience (`vim.g.have_nerd_font = true`)

## Repo map

```text
.
├── dot_config/
│   └── nvim/
│       ├── init.lua
│       ├── lua/pezhvak/
│       │   ├── core/
│       │   ├── plugins/
│       │   ├── disabled-plugins/
│       │   └── plugin-manager.lua
│       └── README.md
└── AGENTS.md
```

## Bootstrap on a new machine

```bash
# 1) Install chezmoi (pick your platform/package manager)
# 2) Initialize from this repo (SSH)
chezmoi init git@github.com:pezhvak/dotfiles.git

# If SSH is not set up yet, use HTTPS
chezmoi init https://github.com/pezhvak/dotfiles.git

# 3) Preview changes safely
chezmoi diff

# 4) Apply
chezmoi apply
```

## Neovim dev loop

Run these from `dot_config/nvim/`:

```bash
stylua --check .
stylua .
```

Inside Neovim:

- `:Lazy sync` to sync plugins
- `:checkhealth pezhvak` to sanity-check runtime dependencies

## Core philosophy

- Keep modules small and focused
- Prefer fast defaults and discoverable keymaps
- Treat config like code: readable, testable, versioned
- Ship improvements continuously, not in giant rewrites

## License

MIT (or: do-whatever-you-want-if-you-learn-something-cool).
