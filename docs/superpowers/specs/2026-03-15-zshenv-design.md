# zshenv Design

**Date:** 2026-03-15
**Status:** Approved

## Overview

Add `files/.zshenv` and `files.tpl/.zshenv.local` to the dot-files repo so that non-interactive zsh shells (cron jobs, vim subshells, tmux panes, scripts) have access to `PATH` (homebrew, `.local/bin`) and `EDITOR`. Machine-specific env vars needed non-interactively (bun) go in a new `~/.zshenv.local` copied from the template.

## Goals

- `files/.zshenv` tracked in repo, symlinked to `~/.zshenv` via `clone_and_link.sh`
- Non-interactive shells get `PATH` (homebrew, `.local/bin`) and `EDITOR=nvim`
- bun `PATH` available in non-interactive shells via `~/.zshenv.local`
- No `/Users/<username>/` hardcoded paths in tracked files
- No double-PATH-prepending in interactive shells (lines removed from `files/.zshrc`)

## Scope

**In scope:**
- `PATH` (`.local/bin`, homebrew) and `EDITOR` only — minimal surface area
- bun as the only machine-specific non-interactive env var on this machine

**Out of scope:**
- pyenv shim setup (`eval "$(pyenv init -)"`) — interactive-only, stays in `.zshrc`
- zoxide, zsh-vi-mode, completions — interactive-only, stay in `.zshrc`
- LM Studio, Antigravity — interactive-only, stay in `.zshrc.local`

## Load Order

```
ALL zsh invocations (scripts, cron, vim, tmux, interactive):
  ~/.zshenv  (→ files/.zshenv)
    ├── export PATH="${HOME}/.local/bin:$PATH"
    ├── [[ -d /opt/homebrew/bin ]] && export PATH=/opt/homebrew/bin:$PATH
    ├── export EDITOR=nvim
    └── [ -f ~/.zshenv.local ] && source ~/.zshenv.local
          └── bun PATH (machine-specific, not in repo)

Interactive shells only (adds on top of .zshenv):
  ~/.zshrc  (→ files/.zshrc)
    ├── pyenv init, zoxide, zsh-vi-mode, completions
    ├── sources ~/.zshrc.local
    │     └── LM Studio, Antigravity, claude-mem alias
    └── sources ~/.zshrc.after
          └── loads all .zshrc.command/* files
```

## File Structure

```
~/dot-files/
├── files/
│   ├── .zshenv          # NEW — minimal env vars, symlinked to ~/.zshenv
│   └── .zshrc           # MODIFY — remove PATH/.local/bin, PATH/homebrew, EDITOR lines
└── files.tpl/
    ├── .zshenv.local    # NEW — template for machine-specific env vars
    └── .zshrc.local     # MODIFY — remove bun section (moves to .zshenv.local)
```

Local machine (not committed):
- `~/.zshenv` → symlink to `~/dot-files/files/.zshenv`
- `~/.zshenv.local` → copied from template, bun entries uncommented
- `~/.zshrc.local` → bun section removed

## Component: `files/.zshenv`

```zsh
export PATH="${HOME}/.local/bin:$PATH"
[[ -d /opt/homebrew/bin ]] && export PATH=/opt/homebrew/bin:$PATH
export EDITOR=nvim

[ -f ~/.zshenv.local ] && source ~/.zshenv.local
```

**Removed from `files/.zshrc`** (these exact lines/blocks):
- `export PATH="${HOME}/.local/bin:$PATH"`
- `[[ -d /opt/homebrew/bin ]] && export PATH=/opt/homebrew/bin:$PATH`
- `export EDITOR=nvim`

## Component: `files.tpl/.zshenv.local`

```zsh
##
# Machine-specific environment variables
# Copy this file to ~/.zshenv.local and customize for each machine.
##

# bun
# [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
# export BUN_INSTALL="$HOME/.bun"
# export PATH="$BUN_INSTALL/bin:$PATH"
```

## Component: `files.tpl/.zshrc.local` (modified)

Remove the bun section. Remaining content:

```zsh
##
# Machine-specific overrides
# Copy this file to ~/.zshrc.local and customize for each machine.
##

# LM Studio CLI
# export PATH="$HOME/.lmstudio/bin:$PATH"

# Antigravity
# export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

# claude-mem plugin (update path on plugin version upgrade)
# alias claude-mem='bun "$HOME/.claude/plugins/cache/thedotmack/claude-mem/<VERSION>/scripts/worker-service.cjs"'

# Optional: additional .zshrc.command files to load (see ~/.dot-files/files/.zshrc.command/)
# Use names NOT already in the standard list (those are always loaded).
# Example for files added later: _ZSHRC_CMD_FILES_OPT=(ruby postgres)
```

## Current Machine Wiring

Steps to apply on toshi's MacBook:

1. Symlink `~/.zshenv`:
   ```bash
   ln -s ~/.dot-files/files/.zshenv ~/.zshenv
   ```

2. Copy and customize `.zshenv.local`:
   ```bash
   cp ~/dot-files/files.tpl/.zshenv.local ~/.zshenv.local
   # then uncomment the bun section
   ```

3. Remove bun from `~/.zshrc.local` (3 lines: `_bun` source, `BUN_INSTALL`, bun `PATH`).

## Success Criteria

- `zsh -n ~/dot-files/files/.zshenv` exits 0
- `zsh -i -c exit; echo "Exit: $?"` prints `Exit: 0` (interactive shell still clean)
- `zsh -c 'echo $EDITOR'` prints `nvim` (non-interactive)
- `zsh -c 'echo $PATH' | tr ':' '\n' | grep homebrew` has output (homebrew in non-interactive PATH)
- `zsh -c 'echo $PATH' | tr ':' '\n' | grep bun` has output (bun in non-interactive PATH)
- No `/Users/` in `files/.zshenv` or `files.tpl/.zshenv.local`
- Interactive shell PATH has no duplicate entries (homebrew not listed twice)
