# Agent Notes

- This repo is a ChezMoi source tree, not a direct Neovim config checkout.
  `dot_*` paths map to dotfiles on apply (for example
  `dot_config/nvim/dot_stylua.toml` becomes `.config/nvim/.stylua.toml`).
- Most real work is under `dot_config/nvim/`.

## Entry Points And Boundaries

- Neovim startup path is `dot_config/nvim/init.lua` ->
  `lua/pezhvak/init.lua` -> `core/*` + `plugin-manager.lua`.
- `plugin-manager.lua` uses `lazy.nvim` with
  `{ import = 'pezhvak.plugins' }`, so every file in
  `lua/pezhvak/plugins/*.lua` is auto-loaded as plugin spec.
- Keep experiments in `lua/pezhvak/disabled-plugins/`; they are not imported.

## Verification Commands

- Run commands from `dot_config/nvim/`.
- Format check: `stylua --check .`
- Apply formatting: `stylua .`
- Runtime sanity check: open `nvim` and run `:checkhealth pezhvak`.
- CI workflow in `dot_config/nvim/dot_github/workflows/stylua.yml` only runs
  when `github.repository == 'nvim-lua/kickstart.nvim'`; do not assume CI
  will validate this fork.

## Repo-Specific Gotchas

- `dot_config/nvim/dot_gitignore` ignores `lazy-lock.json`; avoid lockfile
  churn unless explicitly requested.
- `lua/pezhvak/plugins/go.lua` adds a Go `BufWritePre` autoformat
  (`goimports`), so Go files may change on save.

## Git Safety Rule

- Always ask for explicit user permission before `git commit`.
- Always ask for explicit user permission before any `git push`.

## Commit Message Style

- Follow repo history style: `type(scope): imperative summary`.
  Examples seen: `feat(nvim): ...`, `fix(nvim): ...`,
  `refactor(nvim): ...`, `chore(git): ...`.
- Keep subjects concise, present tense, and scoped (usually `nvim`, sometimes
  `git` for repo housekeeping).
