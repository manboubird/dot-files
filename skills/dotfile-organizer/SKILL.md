---
name: dotfile-organizer
description: Organize, audit, port, and security-scan dot-files based on the current machine environment. Use this skill when the user wants to: audit which .zshrc.command files should be active for their installed tools, figure out what to put in .zshrc.local or .zshenv.local, generate a customized step-by-step setup checklist for a new machine, identify machine-specific config files that should be moved into the git-managed dot-files repo, or scan tracked files for accidentally committed secrets, hardcoded usernames, or privacy leaks before pushing. Trigger whenever the user mentions organizing dot-files, setting up a new machine, porting configs into the repo, auditing their shell configuration, or checking dotfiles for security or privacy issues.
---

# Dotfile Organizer

Four modes — pick based on what the user is asking for:

- **organize**: Scan the environment, cross-reference with the dot-files repo, propose what to enable or configure
- **setup**: Generate a step-by-step machine-specific setup checklist
- **port**: Identify machine-specific config files outside the repo that should be git-managed, and generate the commands to move them in
- **security-scan**: Scan tracked files for secrets, hardcoded usernames, and privacy leaks before they reach git history

---

## Mode 1: Organize

### Step 1: Scan the environment

Run these in parallel:

```bash
# Tool availability
for cmd in ack ag bat bun cheat direnv gcloud ghq httpie ipython mise node nvim peco pet pyenv tmux tree w3m zoxide; do
  command -v "$cmd" &>/dev/null && echo "ok $cmd" || echo "-- $cmd"
done

# Current local configs
cat ~/.zshrc.local 2>/dev/null || echo "(no ~/.zshrc.local)"
cat ~/.zshenv.local 2>/dev/null || echo "(no ~/.zshenv.local)"

# What's in the standard command file list
grep '_ZSHRC_CMD_FILES=' ~/dot-files/files/.zshrc.after 2>/dev/null
```

### Step 2: Map tools to command files

| Command file | Requires | Notes |
|---|---|---|
| `ack` | `ack` | |
| `ag` | `ag` | |
| `cd` | — | Always |
| `cheat` | `cheat` | |
| `curl` | — | Always |
| `df` | — | Always |
| `direnv` | `direnv` | |
| `du` | — | Always |
| `fcd` | `peco` | fuzzy-cd |
| `find` | — | Always |
| `google-cloud-sdk` | `gcloud` | |
| `ghq` | `ghq` | also benefits from `peco` |
| `http` | `httpie` | |
| `ipython` | `ipython` | |
| `less` | — | Always |
| `ls` | — | Always |
| `nodejs` | `node` | |
| `open` | — | macOS, always |
| `openssl` | — | Always |
| `pbcopy` | — | macOS, always |
| `pbpaste` | — | macOS, always |
| `pet` | `pet` | |
| `tmux` | `tmux` | |
| `tree` | `tree` | |
| `w3m` | `w3m` | |

### Step 3: Produce a proposal as a checklist

**A. `.zshenv.local`** — tools needed in non-interactive shells (scripts, cron):
- If `bun` is installed → uncomment the bun block
- Any runtime tool installed outside Homebrew whose PATH must be available to scripts

**B. `.zshrc.local`** — interactive shell settings:
- `export EDITOR=` — detect `nvim` / `vim` / `code` and suggest the right value
- `export PATH=` lines for interactive-only tools (LM Studio, Antigravity)
- `_ZSHRC_CMD_FILES_OPT=(...)` — any installed tools NOT in the standard `_ZSHRC_CMD_FILES` list

**C. Command file audit** — show ✓ for files whose tool is installed, and flag any tool in `_ZSHRC_CMD_FILES_OPT` that could be promoted to the standard list via a PR.

---

## Mode 2: Setup

Run the same environment scan from Mode 1 first, then generate a numbered, copy-pasteable checklist:

```
# Dot-files setup — <hostname> (<YYYY-MM-DD>)

## 1. Clone and link (skip if already done)
git clone git@github.com:<user>/dot-files.git ~/dot-files
ln -s ~/dot-files ~/.dot-files
bash ~/dot-files/setup/clone_and_link.sh

## 2. Install .claude files
mkdir -p ~/.claude
ln -sf ~/dot-files/files/.claude/statusline.sh ~/.claude/statusline.sh

## 3. Install dotfile-organizer skill
mkdir -p ~/.claude/skills
ln -sf ~/dot-files/skills/dotfile-organizer ~/.claude/skills/dotfile-organizer

## 4. Install missing tools
brew install <only what's detected as missing>

## 5. Configure ~/.zshenv.local
cp ~/dot-files/files.tpl/.zshenv.local ~/.zshenv.local
# <exact lines to uncomment based on what's installed>

## 6. Configure ~/.zshrc.local
cp ~/dot-files/files.tpl/.zshrc.local ~/.zshrc.local
# <exact lines to set: EDITOR, PATH entries>

## 7. Verify
zsh -i -c exit; echo "Exit: $?"
zsh -i -c "alias ll; type is_command_exists"
```

Save to `docs/setup/setup-<hostname>.md` (not committed — local reference). Tell the user the path.

---

## Mode 3: Port

Identify config files on this machine that are currently untracked but shareable (no secrets, useful across machines), then generate the commands to move them into the repo.

### Step 1: Scan candidate locations

```bash
# .claude/ files (non-dynamic, non-secret)
ls -la ~/.claude/*.sh ~/.claude/*.json 2>/dev/null | grep -v settings.json

# Already in repo?
ls ~/dot-files/files/.claude/ 2>/dev/null

# Custom scripts
ls ~/.local/bin/ ~/local/bin/ 2>/dev/null

# Other common candidates
ls ~/.ackrc ~/.ctags ~/.screenrc 2>/dev/null
```

### Step 2: Classify each candidate

For each file found, decide:

| Destination | When to use |
|---|---|
| `files/.claude/<file>` | Shareable as-is, no secrets, same on every machine |
| `files.tpl/.claude/<file>` | Has machine-specific values; share as template with placeholders |
| `files/<dotfile>` | Standard dotfile, symlinked by `clone_and_link.sh` |
| Skip | Dynamic state, secrets, or machine-specific data that doesn't generalize |

**Key rules:**
- `~/.claude/settings.json` → `files.tpl/.claude/` (contains machine-specific paths/keys, share as template)
- `~/.claude/statusline.sh` → `files/.claude/` (fully shareable script)
- `~/.claude/` dynamic dirs (`projects/`, `sessions/`, `cache/`, etc.) → skip always

### Step 3: Generate port commands

For each file to port, output the exact commands:

```bash
# Example: statusline.sh
cp ~/.claude/statusline.sh ~/dot-files/files/.claude/statusline.sh
ln -sf ~/dot-files/files/.claude/statusline.sh ~/.claude/statusline.sh
# Then: git add ~/dot-files/files/.claude/statusline.sh
```

**Note:** `~/.claude/` cannot be fully symlinked by `clone_and_link.sh` (the directory already exists with dynamic content). Individual files within it must be symlinked one by one. The setup mode generates these individual symlink commands.

### Step 4: Output a port plan

Present as a checklist:
- `- [ ] Port <file>: move to <repo-path>, symlink from <original-path>`
- After each group, show the `git add` commands to stage them

---

## Mode 4: Security Scan

Scan the tracked and staged files for secrets, personal data, and privacy leaks **before they enter git history**. Run this before any `git push` on this repo.

### Step 1: Scan tracked files for secrets

```bash
# Secret patterns in tracked files
git grep -n -E \
  'export [A-Z_]*(TOKEN|KEY|SECRET|PASSWORD|CREDENTIAL|AUTH)[=\s][^$(<"'"'"']' \
  -- 'files/' 'files.tpl/'

# Private key material
git grep -n 'BEGIN.*PRIVATE KEY' -- 'files/' 'files.tpl/'

# Common token formats
git grep -n -E \
  '(ghp_|gho_|ghu_|ghs_)[A-Za-z0-9]{36}|AKIA[0-9A-Z]{16}' \
  -- 'files/' 'files.tpl/'
```

### Step 2: Scan for hardcoded personal paths

```bash
# Username in paths (should always use $HOME or ~)
git grep -n -E '/Users/[a-zA-Z0-9_]+/' -- 'files/' 'files.tpl/'
git grep -n -E '/home/[a-zA-Z0-9_]+/' -- 'files/' 'files.tpl/'
```

### Step 3: Check for dangerous files accidentally tracked

```bash
# High-risk filenames that should never be committed
git ls-files | grep -E \
  '(\.ssh/|\.gnupg/|\.aws/credentials|\.netrc|\.pypirc|\.npmrc|\.env$|\.env\.)'

# .local files (should all be gitignored)
git ls-files | grep '\.local$'
```

### Step 4: Validate files.tpl/ contains no real values

Templates are safe to commit only if values are commented out or use placeholders. Check:

```bash
# Lines in files.tpl/ that look like active (uncommented) credential exports
grep -rn -E '^export [A-Z_]*(TOKEN|KEY|SECRET|PASSWORD)=' files.tpl/

# Active (uncommented) path entries that look real (not <PLACEHOLDER>)
grep -rn -E '^export PATH=.*/(bin|lib)' files.tpl/ | grep -v '#'
```

### Step 5: Check .gitignore coverage

```bash
# Verify these patterns are covered
for pattern in '*.local' '.env' '.npmrc' '.pypirc' '.netrc' \
               '.aws' '.gnupg' '.ssh'; do
  git check-ignore -q --no-index "$pattern" 2>/dev/null \
    && echo "✓ $pattern" || echo "✗ NOT ignored: $pattern"
done
```

### Output format

Report findings in three categories:

**🔴 Errors** — must fix before pushing (real secrets, private keys, live credentials)
**🟡 Warnings** — review needed (uncommented template values, suspicious patterns)
**✅ Clean** — no issues found in this category

For each finding: show the file, line number, and the matched content. If errors are found, suggest the fix (move the value to a `.local` file, add to `.gitignore`, or replace with a placeholder in `files.tpl/`).

---

## Style rules

- Use `- [ ]` checkboxes for all action items
- Always explain *why* a file belongs where it does ("no secrets + same content on any machine → `files/`")
- Show exact commands — no abstract descriptions
- Distinguish "already in repo" (nothing to do) from "missing" (action required)
