# PATH
export PATH="${HOME}/.local/bin:$PATH"

# Added by homebrew
[[ -d /opt/homebrew/bin ]] && export PATH=/opt/homebrew/bin:$PATH

export EDITOR=nvim

# vim binding via: brew-installed zsh-vi-mode
_ZVM_PLUGIN="$(brew --prefix 2>/dev/null)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh"
[[ -f "$_ZVM_PLUGIN" ]] && source "$_ZVM_PLUGIN"
unset _ZVM_PLUGIN

#
# zsh completion
#
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
  autoload -Uz compinit
  compinit
fi

# Added by pyenv
export PYENV_ROOT="$HOME/.pyenv"
if command -v pyenv &>/dev/null || [[ -d "$PYENV_ROOT/bin" ]]; then
  [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init - zsh)"
  eval "$(pyenv virtualenv-init -)"
fi

# zoxide
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
fi

# Load machine-specific overrides first (defines _ZSHRC_CMD_FILES_OPT if needed)
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# Load command files
[ -f ~/.zshrc.after ] && source ~/.zshrc.after
