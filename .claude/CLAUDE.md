# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A personal dotfiles repository for macOS. Files in `files/` are symlinked to `$HOME` via `setup/clone_and_link.sh`. Files in `files.tpl/` are templates to copy manually — they are never symlinked and never committed.

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

1. **`files/.zshenv`** — sourced by ALL shells (interactive, non-interactive, scripts, cron). Contains only: XDG Base Directory vars, PATH (`.local/bin`, Homebrew), sources `~/.zshenv.local`. Ends with `typeset -U PATH` to deduplicate.
2. **`files/.zshrc`** — interactive shells only. Loads: zsh-vi-mode, completions, pyenv, zoxide, then sources `~/.zshrc.local` and `~/.zshrc.after`.
3. **`files/.zshrc.after`** — the command file loader. Sources `files/.zshrc.command/functions`, then loads each file listed in `_ZSHRC_CMD_FILES` from `files/.zshrc.command/`.

**`files/.zshrc.command/functions`** defines two helpers used throughout command files:
- `is_command_exists <cmd>` — echoes `0` if command exists, `1` if not (inverted from shell exit codes — do NOT change this convention, it's intentional for backward compatibility)
- `source_files <dir> <files...>` — sources each named file from `<dir>`

**`files/.zshrc.command/<tool>`** — one file per tool, guarded with `if [ $(is_command_exists <tool>) -eq 0 ]`.

## Machine-local files (not committed)

| Template | Copy to | Purpose |
|----------|---------|---------|
| `files.tpl/.zshenv.local` | `~/.zshenv.local` | Non-interactive env vars (bun PATH, etc.) |
| `files.tpl/.zshrc.local` | `~/.zshrc.local` | Interactive overrides (EDITOR, optional tool paths) |
| `files.tpl/.gitconfig.local` | `~/.config/git/config.local` | Git user identity |

`~/.zshrc.local` must be sourced before `~/.zshrc.after` (already enforced in `files/.zshrc`) so that `_ZSHRC_CMD_FILES_OPT` is defined when the loader runs.

## Key rules for editing zsh files

- No hardcoded `/Users/<username>/` paths in any tracked file — use `$HOME` or `~`
- `files/.zshenv` must stay minimal and fast: no aliases, no completions, no slow `eval` calls
- `[[ ]]` is preferred over `[ ]` in zsh-only files (`.zshenv`, `.zshrc`, `.zshrc.after`, `.zshrc.command/*`)
- Adding a new tool to the command file system: create `files/.zshrc.command/<tool>` and add the name to `_ZSHRC_CMD_FILES` in `files/.zshrc.after`

## Security and privacy

**Trust boundary — three tiers:**

| Tier | Path | Committed | Contains |
|------|------|-----------|---------|
| Shared | `files/`, `files/.claude/`, `skills/` | Yes | Generic config, no personal data |
| Template | `files.tpl/` | Yes | Structure only — placeholders, all values commented out |
| Local | `~/*.local`, `~/.config/git/config.local` | Never | Real values, machine paths, credentials |

**Hard rules for tracked files:**
- No `export ..._TOKEN=`, `..._KEY=`, `..._SECRET=`, `..._PASSWORD=` with real values
- No hardcoded usernames in paths — always `$HOME` or `~`, never `/Users/<name>/`
- No private key material (`-----BEGIN ... PRIVATE KEY-----`)
- `files.tpl/` entries must have values commented out or replaced with `<PLACEHOLDER>` — the template itself must contain no real values

**Files that must never be committed:**
`~/.zshrc.local`, `~/.zshenv.local`, `~/.config/git/config.local`, `~/.netrc`, `~/.ssh/*`, `~/.aws/credentials`, `~/.gnupg/`, `.env`, `.npmrc`, `.pypirc`

**Before committing any file:** run the `security-scan` mode of the `dotfile-organizer` skill to catch leaks before they hit git history.

## Setup guide

Full new-machine setup: [`docs/setup/zshrc.md`](docs/setup/zshrc.md)

## Brewfiles

- `setup/Brewfile-core` — core tools for all machines
- `setup/Brewfile-dev` — development tools (install selectively)
