# Zsh Environment Setup

## Prerequisites

- macOS with zsh (default since macOS Catalina)
- [Homebrew](https://brew.sh) installed
- dot-files repo cloned (or run setup script below)

## Step 1: Clone and link dot-files

If starting fresh on a new machine:

```bash
git clone git@github.com:<your-username>/dot-files.git ~/dot-files
```

Then create the symlink used by the zsh config:

```bash
ln -s ~/dot-files ~/.dot-files
```

## Step 2: Symlink config files

Run the setup script to symlink all files from `files/` to your home directory:

```bash
bash ~/dot-files/setup/clone_and_link.sh
```

This script symlinks every dotfile in `files/` to the home directory. It will create:
- `~/.zshrc` → `~/dot-files/files/.zshrc`
- `~/.zshrc.after` → `~/dot-files/files/.zshrc.after`
- `~/.zshrc.command/` → `~/dot-files/files/.zshrc.command/`
- (and all other files in `files/`)

Files in `files.tpl/` are NOT touched by this script — they are templates to copy manually (see Step 3).

## Step 3: Copy the local config templates

Copy both local config templates and customize for this machine:

```bash
cp ~/dot-files/files.tpl/.zshenv.local ~/.zshenv.local
cp ~/dot-files/files.tpl/.zshrc.local ~/.zshrc.local
```

**`~/.zshenv.local`** — environment variables needed by all shells (interactive and non-interactive):

| Entry | Tool | Notes |
|-------|------|-------|
| Bun | `~/.bun/_bun` | Uncomment if bun is installed |

**`~/.zshrc.local`** — interactive shell settings (tool paths, optional plugins):

| Entry | Tool | Notes |
|-------|------|-------|
| `EDITOR` | preferred editor | Uncomment and set (e.g. `nvim`) |
| `PATH` LM Studio | `~/.lmstudio/bin` | Uncomment if LM Studio is installed |
| `PATH` Antigravity | `~/.antigravity/...` | Uncomment if Antigravity is installed |
| `claude-mem` alias | Claude plugin | Update `<VERSION>` to match installed version |
| `_ZSHRC_CMD_FILES_OPT` | Optional command files | Add file names to load extra `.zshrc.command/` files |

## Step 4: Install required tools

Install zsh plugins and tools used by the config:

```bash
brew install zsh-vi-mode zsh-completions
brew install pyenv pyenv-virtualenv
brew install zoxide
```

Optional tools (uncomment in `~/.zshrc.local` if installed):

```bash
brew install --cask lm-studio
brew install bun
```

## Step 5: Reload shell

```bash
exec zsh
```

Or open a new terminal. Verify startup is clean:

```bash
zsh -i -c exit; echo "Exit: $?"
# Expected: Exit: 0
```

## Files reference

| File | Type | Purpose |
|------|------|---------|
| `~/dot-files/files/.zshenv` | Symlinked | Environment variables for all shells (PATH, etc.) |
| `~/dot-files/files/.zshrc` | Symlinked | Base zsh config (machine-agnostic, interactive only) |
| `~/dot-files/files/.zshrc.after` | Symlinked | Command file loader |
| `~/dot-files/files/.zshrc.command/` | Symlinked dir | Per-tool aliases and functions |
| `~/dot-files/files.tpl/.zshenv.local` | Template | Copy to `~/.zshenv.local`, do not symlink |
| `~/dot-files/files.tpl/.zshrc.local` | Template | Copy to `~/.zshrc.local`, do not symlink |
| `~/.zshenv.local` | Local only | Machine-specific env vars (bun, etc.) |
| `~/.zshrc.local` | Local only | Machine-specific interactive settings |
| `~/.dot-files` | Symlink | Points to `~/dot-files` |
