# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A personal dotfiles repository for macOS. Files in `dot/` are symlinked to `$HOME` via `setup/clone_and_link.sh`. Filenames under `dot/` have **no leading dots** in the repo — the `.` prefix is prepended at symlink time. Files in `dot/config/` are symlinked to `$XDG_CONFIG_HOME` (`~/.config/`) without a dot prefix. Files in `dot.tpl/` are templates to copy manually — never symlinked, never committed with real values. Machine-specific env files live in `env/<profile>/` within a private fork of this repo (see env/ fork workflow below).

## Shell safety rules

- Never use `rm -rf` in Bash tool calls. Instead, move use `trash` for safe cleanup.

## Verification commands

After editing any zsh config file, always syntax-check it:

```bash
zsh -n <file>
```

After changes that affect shell startup:

```bash
zsh -i -c exit; echo "Exit: $?"          # interactive shell starts cleanly
zsh -c 'echo $PATH' | tr ':' '\n'        # non-interactive PATH
```

## Zsh config architecture

Load order — zsh sources these in sequence:

1. **`dot/zshenv`** — sourced by ALL shells. Contains only: XDG Base Directory vars, PATH (`.local/bin`, Homebrew), sources `~/.zshenv.local`. Ends with `typeset -U PATH`.
2. **`dot/zshrc`** — interactive shells only. Calls `compinit` FIRST (before sourcing zsh-vi-mode — required because zsh-vi-mode calls `zvm_after_init` synchronously during source). Then loads pyenv, sources `~/.zshrc.local` and `~/.zshrc.after`.
3. **`dot/zshrc.after`** — the command file loader. Sources `dot/zshrc.command/functions`, then loads each file listed in `_ZSHRC_CMD_FILES`. `_ZSHRC_CMD_DIR` points to `${HOME}/.dot-files/dot/zshrc.command` (the repo-side path, not the symlink path `~/.zshrc.command`).

**`dot/zshrc.command/functions`** defines two helpers:
- `is_command_exists <cmd>` — echoes `0` if command exists, `1` if not (inverted convention — do NOT change)
- `source_files <dir> <files...>` — sources each named file from `<dir>`

**`dot/zshrc.command/<tool>`** — one file per tool, guarded with `if [[ $(is_command_exists <tool>) -eq 0 ]]`.

**`dot/zshrc.command/zoxide`** — special: defines `zvm_after_init()` which calls `eval "$(zoxide init zsh)"`. This is the **sole owner** of the `zvm_after_init` hook. If another command file needs this hook, both must be combined into one function definition.

**`[[ ]]` vs `[ ]`:** `[[ ]]` is preferred in zsh-only files (`dot/zshenv`, `dot/zshrc`, `dot/zshrc.after`, `dot/zshrc.command/*`). Bash scripts (`setup/*.sh`, `local/bin/*.sh`) use `[ ]`.

## Machine-local files (not committed)

| Template | Copy to | Purpose |
|----------|---------|---------|
| `dot.tpl/gitconfig.local.tpl` | `~/.config/git/config.local` | Git user identity |
| `env/default/.zshenv.local` | via `link_dot_env.sh` | Non-interactive env vars — set `DOTFILE_MACHINE_PROFILE` here |
| `env/default/.zshrc.local` | via `link_dot_env.sh` | Interactive overrides |

For machine env files, see the env/ fork workflow below.

## env/ fork workflow

`env/default/` is committed to the public repo with placeholder values only. Machine-specific files (`env/<profile>/`) live only in a private fork hosted on a private network.

- Set `DOTFILE_MACHINE_PROFILE=<profile>` in `env/<profile>/.zshenv.local` (committed to private fork)
- Run `DOTFILE_MACHINE_PROFILE=<profile> bash setup/link_dot_env.sh` on first setup
- Git remotes: `origin` = private fork, `upstream` = public GitHub

## Key rules for editing zsh files

- No hardcoded `/Users/<username>/` paths in any tracked file — use `$HOME` or `~`
- `dot/zshenv` must stay minimal and fast: no aliases, no completions, no slow `eval` calls
- `[[ ]]` is preferred over `[ ]` in zsh-only files (`dot/zshenv`, `dot/zshrc`, `dot/zshrc.after`, `dot/zshrc.command/*`)
- Adding a new tool to the command file system: create `dot/zshrc.command/<tool>` and add the name to `_ZSHRC_CMD_FILES` in `dot/zshrc.after`

## Security and privacy

**Trust boundary — three tiers:**

| Tier | Path | Committed | Contains |
|------|------|-----------|---------|
| Shared | `dot/`, `dot.tpl/`, `skills/` | Yes | Generic config, no personal data |
| Template | `env/default/` | Yes | Structure only — all values commented out |
| Local | `env/<profile>/`, `~/*.local`, `~/.config/git/config.local` | Never (private fork only) | Real values, machine paths, credentials |

**Hard rules for tracked files:**
- No `export ..._TOKEN=`, `..._KEY=`, `..._SECRET=`, `..._PASSWORD=` with real values
- No hardcoded usernames in paths — always `$HOME` or `~`, never `/Users/<name>/`
- No private key material (`-----BEGIN ... PRIVATE KEY-----`)
- `dot.tpl/` entries must have values commented out or replaced with `<PLACEHOLDER>` — the template itself must contain no real values

**Files that must never be committed:**
`~/.zshrc.local`, `~/.zshenv.local`, `~/.config/git/config.local`, `~/.netrc`, `~/.ssh/*`, `~/.aws/credentials`, `~/.gnupg/`, `.env`, `.npmrc`, `.pypirc`

**Before committing any file:** run the `security-scan` mode of the `dotfile-organizer` skill to catch leaks before they hit git history.

## Setup guide

Full new-machine setup: [`docs/setup/zshrc.md`](docs/setup/zshrc.md)

## Brewfiles

- `setup/Brewfile-core` — core tools for all machines
- `setup/Brewfile-dev` — development tools (install selectively)
