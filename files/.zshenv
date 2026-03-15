export PATH="${HOME}/.local/bin:$PATH"
[[ -d /opt/homebrew/bin ]] && export PATH=/opt/homebrew/bin:$PATH

[[ -f ~/.zshenv.local ]] && source ~/.zshenv.local

typeset -U PATH
