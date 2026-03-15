# Dotfile Organizer Skill — Setup

The `dotfile-organizer` skill helps you audit, configure, and port dot-files based on your machine's installed tools.

## Install the skill

The skill is bundled in the dot-files repo as a Claude Code plugin. Install it once via the Claude Code `/plugin` command.

**If you installed the dot-files repo from GitHub:**

```
/plugin marketplace add manboubird/dot-files
/plugin install dotfile-organizer@dot-files
```

**If you have the repo cloned locally:**

```
/plugin marketplace add ~/dot-files
/plugin install dotfile-organizer@dot-files
```

Run `/reload-plugins` if the skill doesn't appear immediately.

## Install .claude files

Files in `files/.claude/` are git-managed but require a manual one-time copy since `clone_and_link.sh` cannot safely replace your live `~/.claude/` directory.

```bash
cp ~/dot-files/files/.claude/statusline.sh ~/.claude/statusline.sh
```

## What the skill does

| Mode | Example trigger | Output |
|------|----------------|--------|
| **organize** | "what should I configure in .zshrc.local?" | Checklist of .zshenv.local and .zshrc.local entries based on installed tools |
| **setup** | "generate a setup checklist for this machine" | Numbered guide saved to `docs/setup/setup-<hostname>.md` |
| **port** | "what configs should I move into the repo?" | Candidate files with exact move + copy commands |
