# vim binding + zsh completion via homebrew
_BREW_PREFIX="$(brew --prefix 2>/dev/null)"
if [[ -n "$_BREW_PREFIX" ]]; then
  _ZVM_PLUGIN="${_BREW_PREFIX}/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh"
  [[ -f "$_ZVM_PLUGIN" ]] && source "$_ZVM_PLUGIN"
  unset _ZVM_PLUGIN

  FPATH="${_BREW_PREFIX}/share/zsh-completions:$FPATH"
  autoload -Uz compinit
  compinit
fi
unset _BREW_PREFIX

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
if [[ -d "$PYENV_ROOT/bin" ]]; then
  export PATH="$PYENV_ROOT/bin:$PATH"
fi
if command -v pyenv &>/dev/null; then
  eval "$(pyenv init - zsh)"
  [[ -d "$PYENV_ROOT/plugins/pyenv-virtualenv" ]] && eval "$(pyenv virtualenv-init -)"
fi

# zoxide
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
fi

# Load machine-specific overrides first (defines _ZSHRC_CMD_FILES_OPT if needed)
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# Load command files
[[ -f ~/.zshrc.after ]] && source ~/.zshrc.after
