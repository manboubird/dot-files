---
name: dotfile-organizer
description: Organize, audit, port, security-scan, symlink-audit, and recover dot-files based on the current machine environment. Use this skill when the user wants to: audit which .zshrc.command files should be active for their installed tools, figure out what to put in .zshrc.local or .zshenv.local, generate a customized step-by-step setup checklist for a new machine, identify machine-specific config files that should be moved into the git-managed dot-files repo, scan tracked files for accidentally committed secrets/hardcoded usernames/privacy leaks before pushing, inspect current symlinks to find stale/broken/nested links before running link_dotfiles.sh, or restore accidentally-deleted .local files and private dotfiles from a backup folder like ~/.Trash. Trigger whenever the user mentions organizing dot-files, setting up a new machine, porting configs, auditing shell configuration, checking for security issues, auditing symlinks, or recovering/restoring deleted local config files.
---

# Dotfile Organizer

Six modes — pick based on what the user is asking for:

- **organize**: Scan the environment, cross-reference with the dot-files repo, propose what to enable or configure
- **setup**: Generate a step-by-step machine-specific setup checklist
- **port**: Identify machine-specific config files outside the repo that should be git-managed, and generate the commands to move them in
- **security-scan**: Scan tracked files for secrets, hardcoded usernames, and privacy leaks before they reach git history
- **symlink-audit**: Inspect current symlinks in `~/` and `~/.config/` — find broken, stale, nested, and old-path links, then advise what to clean up before running `link_dotfiles.sh` or `link_dotfiles_local.sh`
- **recover**: Restore accidentally-deleted `.local` files and other private dotfiles from a backup folder (e.g. `~/.Trash`) back to `$HOME`

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
grep '_ZSHRC_CMD_FILES=' ~/.dot-files/dot/zshrc.after 2>/dev/null
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
git clone git@your-private-server:you/dot-files.git ~/.dot-files
bash ~/.dot-files/setup/clone_and_link.sh

## 2. Link machine env profile
DOTFILE_MACHINE_PROFILE=<profile> bash ~/.dot-files/setup/link_dot_env.sh

## 3. Install .claude files
ln -sf ~/.dot-files/dot/claude/statusline.sh ~/.claude/statusline.sh

## 4. Install dotfile-organizer skill
mkdir -p ~/.claude/skills
ln -sf ~/.dot-files/skills/dotfile-organizer ~/.claude/skills/dotfile-organizer

## 5. Install missing tools
brew install <only what's detected as missing>

## 6. Verify
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
ls ~/.dot-files/dot/claude/ 2>/dev/null

# Custom scripts
ls ~/.local/bin/ ~/local/bin/ 2>/dev/null

# Other common candidates
ls ~/.ackrc ~/.ctags ~/.screenrc 2>/dev/null
```

### Step 2: Classify each candidate

For each file found, decide:

| Destination | When to use |
|---|---|
| `dot/claude/<file>` | Shareable as-is, no secrets, same on every machine |
| `dot.tpl/` | Has machine-specific values that are generic; share as template with placeholders |
| `dot/<dotfile>` | Standard dotfile (no leading dot), symlinked as `~/.<name>` by `clone_and_link.sh` |
| `env/<profile>/` | Machine-specific values with real data; only in private fork |
| Skip | Dynamic state, secrets, or machine-specific data that doesn't generalize |

**Key rules:**
- `~/.claude/settings.json` → `dot.tpl/` (contains machine-specific paths/keys, share as template)
- `~/.claude/statusline.sh` → `dot/claude/` (fully shareable script)
- `~/.claude/` dynamic dirs (`projects/`, `sessions/`, `cache/`, etc.) → skip always

### Step 3: Generate port commands

For each file to port, output the exact commands:

```bash
# Example: statusline.sh
cp ~/.claude/statusline.sh ~/.dot-files/dot/claude/statusline.sh
ln -sf ~/.dot-files/dot/claude/statusline.sh ~/.claude/statusline.sh
# Then: git add ~/.dot-files/dot/claude/statusline.sh
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
  -- 'dot/' 'dot.tpl/' 'env/'

# Private key material
git grep -n 'BEGIN.*PRIVATE KEY' -- 'dot/' 'dot.tpl/'

# Common token formats
git grep -n -E \
  '(ghp_|gho_|ghu_|ghs_)[A-Za-z0-9]{36}|AKIA[0-9A-Z]{16}' \
  -- 'dot/' 'dot.tpl/'
```

### Step 2: Scan for hardcoded personal paths

```bash
# Username in paths (should always use $HOME or ~)
git grep -n -E '/Users/[a-zA-Z0-9_]+/' -- 'dot/' 'dot.tpl/'
git grep -n -E '/home/[a-zA-Z0-9_]+/' -- 'dot/' 'dot.tpl/'
```

### Step 3: Check for dangerous files accidentally tracked

```bash
# High-risk filenames that should never be committed
git ls-files | grep -E \
  '(\.ssh/|\.gnupg/|\.aws/credentials|\.netrc|\.pypirc|\.npmrc|\.env$|\.env\.)'

# .local files (should all be gitignored)
git ls-files | grep '\.local$'
```

### Step 4: Validate dot.tpl/ and env/default/ contain no real values

Templates are safe to commit only if values are commented out or use placeholders. Check:

```bash
# Lines in dot.tpl/ or env/default/ that look like active (uncommented) credential exports
grep -rn -E '^export [A-Z_]*(TOKEN|KEY|SECRET|PASSWORD)=' dot.tpl/ env/default/

# Active (uncommented) path entries that look real (not <PLACEHOLDER>)
grep -rn -E '^export PATH=.*/(bin|lib)' dot.tpl/ env/default/ | grep -v '#'
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

For each finding: show the file, line number, and the matched content. If errors are found, suggest the fix (move the value to a `.local` file, add to `.gitignore`, or replace with a placeholder in `dot.tpl/`).

---

## Mode 5: Symlink Audit

Scan the current machine's symlinks and report what needs attention before running `link_dotfiles.sh` or `link_dotfiles_local.sh`. The goal is to surface anything that would produce unexpected results — or silently succeed while leaving stale state behind.

### Step 1: Scan symlinks in `~/` and `~/.config/`

Run all three scans in parallel:

```bash
# Symlinks in ~/ pointing to the dotfiles repos
DOT_FILES="${DOT_FILES:-$HOME/.dot-files}"
DOT_FILES_LOCAL="${DOT_FILE_LOCAL_DIR:-$HOME/.dot-files.local}"

echo "=== HOME dotfile symlinks ==="
for f in "$HOME"/.*; do
  [ -L "$f" ] || continue
  target=$(readlink "$f")
  name=$(basename "$f")
  [[ "$target" == "$DOT_FILES/"* || "$target" == "$DOT_FILES_LOCAL/"* ]] || continue
  if [ -e "$f" ]; then
    [ -d "$target" ] && state="dir-target" || state="ok"
  else
    state="BROKEN"
  fi
  echo "$state | $name | $target"
done
```

```bash
# Symlinks in ~/.config/ pointing to the dotfiles repos
DOT_FILES="${DOT_FILES:-$HOME/.dot-files}"

echo "=== XDG config symlinks ==="
for f in "$HOME/.config"/*; do
  [ -L "$f" ] || continue
  target=$(readlink "$f")
  [[ "$target" == "$DOT_FILES/"* ]] || continue
  name=$(basename "$f")
  if [ -e "$f" ]; then
    [ -d "$target" ] && state="dir-target" || state="ok"
  else
    state="BROKEN"
  fi
  echo "$state | $name | $target"
done
```

```bash
# Find old-path symlinks (pre-refactoring layout: files/common/ or files/<host>/)
echo "=== Old-path symlinks ==="
for f in "$HOME"/.* "$HOME/.config"/*; do
  [ -L "$f" ] || continue
  target=$(readlink "$f")
  [[ "$target" == *"/files/"* ]] && echo "OLD_PATH | $(basename "$f") | $target"
done

# Check for nested symlinks: evidence of ln -sf being called on an existing dir-target symlink
echo "=== Nested symlinks (dir-inside-dir) ==="
for f in "$HOME"/.* "$HOME/.config"/*; do
  [ -L "$f" ] || continue
  target=$(readlink -f "$f" 2>/dev/null)
  [ -z "$target" ] && continue
  name=$(basename "$f")
  # Nested: target path ends in name/name (dir was already a symlink, got nested)
  [[ "$target" == *"/$name/$name" ]] && echo "NESTED | $f | $target"
done
```

### Step 2: Cross-reference with script configuration

```bash
# Load DOT_EXCLUDE and DOT_DEFAULT from the script source
DOT_FILES="${DOT_FILES:-$HOME/.dot-files}"
SCRIPT="$DOT_FILES/setup/link_dotfiles.sh"

echo "=== DOT_EXCLUDE (never linked) ==="
grep -A 30 'DOT_EXCLUDE=(' "$SCRIPT" | awk '/^\)/{exit} /^  /{print $1}'

echo "=== DOT_DEFAULT (expected to be linked) ==="
grep -A 10 'DOT_DEFAULT=(' "$SCRIPT" | awk '/^\)/{exit} /^  /{print $1}'
```

Then, for each entry in `DOT_EXCLUDE`: check if `~/.<name>` is still symlinked (it shouldn't be — flag as "excluded but still present").

For each entry in `DOT_DEFAULT`: check if `~/.<name>` is symlinked to the repo's `dot/<name>` (it should be — flag as "expected but missing").

### Step 3: Classify findings

Group results into four categories:

**🔴 Must fix before running link scripts**
- **Broken symlinks** — target path no longer exists; the link script will not recreate these automatically if the file no longer exists in `dot/`
- **Nested symlinks** — `~/.config/foo/foo` or similar; indicates the old script ran while the target was already a dir-symlink; requires manual cleanup first

**🟡 Review recommended**
- **Dir-target symlinks** — `link_one()` in the current script handles these correctly (removes before re-linking), but they're worth knowing about
- **Old-path symlinks** — pointing to `files/common/` or `files/<host>/` from the pre-refactoring layout; the new script won't update these unless the file now lives under `dot/`
- **Excluded but still present** — a file is in `DOT_EXCLUDE` but still symlinked; the link script won't remove it, so it'll persist indefinitely unless cleaned up manually

**🟢 Expected and correct**
- All `DOT_DEFAULT` entries present and pointing to the right `dot/<name>` path

**ℹ️ Informational**
- Symlinks pointing to `~/.dot-files.local/` (private overlay) — these are managed by `link_dotfiles_local.sh`, not `link_dotfiles.sh`

### Step 4: Output cleanup commands

For each finding that requires action, emit the exact command:

```bash
# Broken symlink — just remove it; re-run link script if you want it back
rm ~/.zshrc.after    # broken: target /old/path/dot/zshrc.after no longer exists

# Nested symlink — remove the outer dir-symlink, then re-run link script
rm -rf ~/.config/cheat   # was: ~/.config/cheat -> dir, ln -sf then created ~/.config/cheat/cheat

# Old-path symlink — re-link to new location
ln -sf ~/.dot-files/dot/zshrc ~/.zshrc   # was: -> old/files/common/.zshrc
```

After cleanup commands, remind the user to re-run the appropriate script:
```bash
bash ~/.dot-files/setup/link_dotfiles.sh
# and/or
bash ~/local/bin/link_dotfiles_local.sh
```

### Output format

Lead with a one-line summary (e.g. "3 issues found: 1 broken, 1 nested, 1 old-path"), then show the categorized findings, then the cleanup commands. Use `- [ ]` checkboxes for cleanup actions.

---

## Mode 6: Recover

Restore private `.local` files and machine-specific dotfiles that were accidentally deleted, after the user points you to a backup folder (e.g. `~/.Trash`, a Time Machine snapshot, a zip extract).

These files are never committed to git — so if they're gone, the only copy is in a backup. The goal is to find the right versions, confirm with the user, and copy them back safely.

### Step 1: Get the backup location from the user

Ask: "Where should I look for the backup? (e.g. `~/.Trash`, a folder path, or press Enter for `~/.Trash`)"

If the user provides no path, default to `~/.Trash`.

### Step 2: Scan the backup folder for candidate files

Search the backup folder (recursively) for files matching the known list of private dotfiles. Show each match with its last-modified date so the user can identify the right version if multiple copies exist.

```bash
BACKUP="${1:-$HOME/.Trash}"

# Known private dotfile names to look for
TARGETS=(
  .zshrc.local .zshenv.local
  .gitconfig .npmrc .netrc .pypirc
  .ssh .gnupg .aws
)

echo "Scanning $BACKUP for private dotfiles..."
for name in "${TARGETS[@]}"; do
  # Search one level deep (Trash layout) and also recursively
  while IFS= read -r found; do
    [ -e "$found" ] || continue
    modified=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M" "$found" 2>/dev/null || \
               stat --format="%y" "$found" 2>/dev/null | cut -c1-16)
    echo "  $modified  $found"
  done < <(find "$BACKUP" -name "$name" 2>/dev/null | sort)
done
```

### Step 3: Build a restore plan

For each candidate found, determine the restore destination:

| Found file | Restore to |
|---|---|
| `.zshrc.local` | `$HOME/.zshrc.local` |
| `.zshenv.local` | `$HOME/.zshenv.local` |
| `.gitconfig` | `$HOME/.gitconfig` |
| `.npmrc` | `$HOME/.npmrc` |
| `.netrc` | `$HOME/.netrc` |
| `.pypirc` | `$HOME/.pypirc` |
| `.ssh/` | `$HOME/.ssh/` (directory — see note) |
| `.gnupg/` | `$HOME/.gnupg/` (directory — see note) |
| `.aws/` | `$HOME/.aws/` (directory — see note) |

**If the user mentioned a specific file or set of files, prioritize those.** If multiple timestamped versions of the same file are found, show them all and ask the user which one to use.

**Directory note (`.ssh`, `.gnupg`, `.aws`):** Restoring directories is higher-risk than restoring files — existing contents may be overwritten. Flag these and ask explicitly before proceeding: "Restore `.ssh/` from backup? This will overwrite any existing `~/.ssh/` contents."

### Step 4: Confirm with the user

Present the restore plan as a checklist and ask for confirmation before touching anything:

```
Found the following files to restore:

  - [ ] ~/.zshrc.local   ← ~/.Trash/.zshrc.local  (2026-03-20 14:32)
  - [ ] ~/.zshenv.local  ← ~/.Trash/.zshenv.local  (2026-03-20 14:32)
  - [ ] ~/.gitconfig     ← ~/.Trash/.gitconfig      (2026-03-19 09:15)

Should I restore all of these? (yes / no / list numbers to select, e.g. "1 3")
```

Wait for the user's answer before proceeding.

### Step 5: Restore the confirmed files

For each confirmed file, copy (not move) from the backup to the destination. If the destination already exists, warn and ask before overwriting:

```bash
# Check before overwriting
if [ -e "$DEST" ]; then
  echo "WARNING: $DEST already exists. Overwrite? (y/n)"
  # wait for user response
fi
cp "$SRC" "$DEST"
echo "Restored: $DEST"
```

Set correct permissions on sensitive files after copy:

```bash
chmod 600 ~/.netrc ~/.npmrc ~/.pypirc 2>/dev/null
chmod 700 ~/.ssh ~/.gnupg 2>/dev/null
chmod 600 ~/.ssh/* ~/.gnupg/* 2>/dev/null
```

### Step 6: Post-recovery verification and next steps

After restoring, verify and advise:

```bash
# Confirm the files are now in place
for f in ~/.zshrc.local ~/.zshenv.local ~/.gitconfig ~/.npmrc ~/.netrc; do
  [ -e "$f" ] && echo "✓ $f" || echo "✗ missing: $f"
done
```

Then remind the user of any follow-up steps:

- If `.zshenv.local` was restored and contains `DOTFILE_MACHINE_PROFILE`, re-run:
  ```bash
  DOTFILE_MACHINE_PROFILE=<profile> bash ~/.dot-files/setup/link_dot_env.sh
  ```
- If `link_dotfiles_local.sh` uses these files as `PREDEFINED_DEFAULTS`, re-run:
  ```bash
  bash ~/local/bin/link_dotfiles_local.sh
  ```
- If `.gitconfig` was restored, verify git identity:
  ```bash
  git config --global user.name; git config --global user.email
  ```

---

## Style rules

- Use `- [ ]` checkboxes for all action items
- Always explain *why* a file belongs where it does ("no secrets + same content on any machine → `dot/`")
- Show exact commands — no abstract descriptions
- Distinguish "already in repo" (nothing to do) from "missing" (action required)
