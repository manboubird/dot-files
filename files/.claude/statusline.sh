#!/usr/bin/env bash
# ~/.claude/statusline.sh
# Claude Code status line script
# Receives JSON from Claude Code via stdin

input=$(cat)

# ── 1. 現在のフォルダ名 ──────────────────────────────────────────────────────
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
[ -z "$cwd" ] && cwd="$(pwd)"
folder=$(basename "$cwd")

# ── 2. Git リポジトリ名 | ブランチ名 ────────────────────────────────────────
git_line=""
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
  repo=$(basename "$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null)")
  branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null \
           || git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
  git_line="${repo} | ${branch}"
fi

# ── 3. コンテキスト使用量 | モデル ──────────────────────────────────────────
model=$(echo "$input" | jq -r '.model.display_name // ""')

used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
total=$(echo "$input" | jq -r '.context_window.context_window_size // empty')
used_tokens=$(echo "$input" | jq -r '.context_window.current_usage.input_tokens // empty')

if [ -n "$used_tokens" ] && [ -n "$total" ] && [ -n "$used_pct" ]; then
  used_k=$(awk "BEGIN {printf \"%.1fk\", $used_tokens/1000}")
  total_k=$(awk "BEGIN {printf \"%.0fk\", $total/1000}")
  pct=$(printf "%.0f" "$used_pct")
  ctx_line="コンテキスト: ${used_k}/${total_k} (${pct}%) | ${model}"
elif [ -n "$model" ]; then
  ctx_line="コンテキスト: - | ${model}"
else
  ctx_line="コンテキスト: -"
fi

# ── 4. 累計トークン使用量 (5h/7d はAPI未提供のため、セッション累計で代替) ──
total_in=$(echo "$input" | jq -r '.context_window.total_input_tokens // empty')
total_out=$(echo "$input" | jq -r '.context_window.total_output_tokens // empty')

if [ -n "$total_in" ] && [ -n "$total_out" ]; then
  total_in_k=$(awk "BEGIN {printf \"%.1fk\", $total_in/1000}")
  total_out_k=$(awk "BEGIN {printf \"%.1fk\", $total_out/1000}")
  reset_7d=$(date -v+7d +"%m/%d" 2>/dev/null || date --date="+7 days" +"%m/%d" 2>/dev/null || echo "?")
  reset_5h=$(date -v+5H +"%H:%M" 2>/dev/null || date --date="+5 hours" +"%H:%M" 2>/dev/null || echo "?")
  usage_line="セッション計: 入力${total_in_k} 出力${total_out_k} | 5hリセット: ${reset_5h}  7dリセット: ${reset_7d}"
else
  usage_line="使用量: データなし"
fi

# ── 出力 ─────────────────────────────────────────────────────────────────────
printf "%s\n" "$folder"
[ -n "$git_line" ] && printf "%s\n" "$git_line"
printf "%s\n" "$ctx_line"
printf "%s\n" "$usage_line"