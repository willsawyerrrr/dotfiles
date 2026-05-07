# CLAUDE.md

## Repo purpose

Personal macOS dotfiles. Config files live under `dot-<name>/` directories and are deployed into `$HOME` via GNU Stow's `--dotfiles` mode (which rewrites the `dot-` prefix to a leading `.`). For example, `dot-config/nvim/init.lua` → `~/.config/nvim/init.lua`, and `dot-zshenv` → `~/.zshenv`.

## Workflows

Workflows are wrapped in `Taskfile.yaml` — run `task --list` to see them.

## Architecture notes

- **What gets symlinked**: system/app config files (anything that belongs in `$HOME`) are symlinked; repo-management files (`Brewfile`, `Taskfile.yaml`, `install.sh`, the `dracula/` submodules, etc.) stay in the repo only. The latter must be listed in `.stow-local-ignore`. Pattern syntax is documented at the top of that file (regex, not gitignore globs — plain pattern matches at any depth, `^/foo` matches only at the repo root).
- **Zsh XDG redirection**: `dot-zshenv` is the only zsh file at `$HOME` and exists solely to set `ZDOTDIR=$XDG_CONFIG_HOME/zsh` and source `${ZDOTDIR}/.zshenv`. Edit real zsh config under `dot-config/zsh/`, not `dot-zshenv`.
- **Claude config** is tracked under `dot-claude/`. Machine-specific overrides go in `.claude/settings.local.json` (stow-ignored). Per the global CLAUDE.md, prefer editing `dot-claude/CLAUDE.md` over auto-memory for persistent global preferences.
- **Dracula themes** are vendored as git submodules under `dracula/` and referenced from individual app configs. After cloning, run `git submodule update --init --recursive` (or clone with `--recurse-submodules`).

## Conventions

- Commit messages follow Conventional Commits with the first word after the type capitalised (e.g. `feat(nvim): Add keymap`).
