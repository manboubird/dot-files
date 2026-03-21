# Zsh Environment Setup

## New machine setup

### Prerequisites
- Homebrew installed
- Private fork of this repo set up on your private network with `env/<profile>/` committed

### Steps

1. **Prepare your private fork** (one-time per machine):
   In your private fork, create `env/<profile>/` with real values and commit:
   - `env/<profile>/.zshenv.local` — set `export DOTFILE_MACHINE_PROFILE=<profile>` and PATH additions
   - `env/<profile>/.zshrc.local` — set `EDITOR`, tool configs, etc.

2. **Clone and link dotfiles:**
   ```bash
   git clone git@your-private-server:you/dot-files.git ~/.dot-files
   bash ~/.dot-files/setup/link_dotfiles.sh
   ```
   This links `dot/*` → `~/.*`, `dot/config/*` → `~/.config/*`, and `local/bin/*` → `~/local/bin/*`.

3. **Link your machine env profile** (pass profile name explicitly on first run):
   ```bash
   DOTFILE_MACHINE_PROFILE=<profile> bash ~/.dot-files/setup/link_dot_env.sh
   ```
   After this, `~/.zshenv.local` is a symlink to `env/<profile>/.zshenv.local` (which sets `DOTFILE_MACHINE_PROFILE` for future shells).

4. **Create `~/.config/git/config.local`** from the template:
   ```bash
   cp ~/.dot-files/dot.tpl/gitconfig.local.tpl ~/.config/git/config.local
   # Edit and fill in your name, email, and GitHub username
   ```

5. **Link private local dotfiles** (if you have a `.dot-files.local` repo):
   ```bash
   link_dotfiles_local.sh
   ```
   (`link_dotfiles_local.sh` is on PATH via step 2 — it lives in `local/bin/`.)

6. **Install required tools:**
   ```bash
   brew install zsh-vi-mode zsh-completions
   brew install pyenv pyenv-virtualenv
   brew install zoxide
   ```

7. **Install the dotfile-organizer skill:**
   ```bash
   mkdir -p ~/.claude/skills
   ln -sf ~/.dot-files/skills/dotfile-organizer ~/.claude/skills/dotfile-organizer
   ```
   See [`docs/setup/dotfile-organizer.md`](dotfile-organizer.md) for full setup options including the Claude marketplace config method.

8. **Verify shell starts cleanly:**
   ```bash
   zsh -i -c exit; echo "Exit: $?"
   ```
   Expected: `Exit: 0`

### Pulling upstream public updates

```bash
cd ~/.dot-files
git remote add upstream git://github.com/manboubird/dot-files.git
git fetch upstream && git merge upstream/main
```

## Files reference

| File | Type | Purpose |
|------|------|---------|
| `~/.dot-files/dot/zshenv` | Symlinked as `~/.zshenv` | Environment variables for all shells (PATH, XDG, etc.) |
| `~/.dot-files/dot/zshrc` | Symlinked as `~/.zshrc` | Base zsh config (machine-agnostic, interactive only) |
| `~/.dot-files/dot/zshrc.after` | Symlinked as `~/.zshrc.after` | Command file loader |
| `~/.dot-files/dot/zshrc.command/` | Symlinked as `~/.zshrc.command/` | Per-tool aliases and functions |
| `~/.dot-files/env/<profile>/.zshenv.local` | Symlinked as `~/.zshenv.local` | Machine-specific env vars (set via `link_dot_env.sh`) |
| `~/.dot-files/env/<profile>/.zshrc.local` | Symlinked as `~/.zshrc.local` | Machine-specific interactive settings |
| `~/.dot-files/dot/claude/statusline.sh` | Symlinked as `~/.claude/statusline.sh` | Claude Code status line script |
| `~/.dot-files/skills/dotfile-organizer/` | Symlinked as `~/.claude/skills/dotfile-organizer/` | Dotfile organizer Claude skill |
| `~/.config/git/config.local` | Not symlinked — copy from `dot.tpl/gitconfig.local.tpl` | Git user identity (name, email, GitHub username) |

## Setup scripts reference

| Script | Purpose |
|--------|---------|
| `setup/link_dotfiles.sh` | Bootstrap: clone repo if absent, symlink all `dot/` files to `~/` and `~/.config/` |
| `setup/link_dot_env.sh` | Link `env/<profile>/` files to `~/` (`.zshenv.local`, `.zshrc.local`) |
| `local/bin/link_dotfiles_local.sh` | Link private `~/.dot-files.local/` overlay files to `~/` |
