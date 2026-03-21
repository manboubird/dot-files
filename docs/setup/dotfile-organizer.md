# Dotfile Organizer Skill — Setup

The `dotfile-organizer` skill helps you audit, configure, port, and recover dot-files based on your machine's environment. It is bundled in the dot-files repo under `skills/dotfile-organizer/`.

## Install the skill

### Option A: Symlink (recommended for local use)

Make the skill available to Claude Code by symlinking it from the repo into `~/.claude/skills/`:

```bash
mkdir -p ~/.claude/skills
ln -sf ~/.dot-files/skills/dotfile-organizer ~/.claude/skills/dotfile-organizer
```

Claude Code discovers skills in `~/.claude/skills/` automatically — no restart needed.

### Option B: Claude marketplace config (locally cloned repo)

If you want Claude Code to manage the skill as a plugin from the local clone, add the repo path as a marketplace in `~/.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "dot-files": {
      "source": {
        "source": "local",
        "path": "~/.dot-files"
      }
    }
  },
  "enabledPlugins": {
    "dotfile-organizer@dot-files": true
  }
}
```

Then install via Claude Code:

```
/add-plugin-marketplace dot-files ~/.dot-files
/install-plugin dotfile-organizer@dot-files
```

> **Note:** Use the local path option if the repo is private or not hosted on GitHub. If you prefer to point at GitHub directly, replace `"source": "local", "path": "~/.dot-files"` with `"source": "github", "repo": "manboubird/dot-files"`.

## Install `.claude` files

`dot/claude/` contains files managed by git that must be individually symlinked into `~/.claude/` (Claude Code's live directory cannot be fully replaced by a symlink):

```bash
ln -sf ~/.dot-files/dot/claude/statusline.sh ~/.claude/statusline.sh
```

This is handled automatically by `setup/link_dotfiles.sh` — no manual step needed after the initial setup.

## What the skill does

| Mode | Example trigger | Output |
|------|----------------|--------|
| **organize** | "what should I configure in .zshrc.local?" | Checklist of `.zshenv.local` and `.zshrc.local` entries based on installed tools |
| **setup** | "generate a setup checklist for this machine" | Numbered guide saved to `docs/setup/setup-<hostname>.md` |
| **port** | "what configs should I move into the repo?" | Candidate files with exact move + symlink commands |
| **security-scan** | "scan for secrets before I push" | Report of secrets, hardcoded paths, and dangerous files in tracked files |
| **symlink-audit** | "audit my current symlinks" | Broken/nested/old-path/excluded symlinks in `~/` and `~/.config/`, with cleanup commands |
| **recover** | "restore my deleted .local files" | Scans a backup folder (e.g. `~/.Trash`) for private dotfiles, confirms, and copies them back |
