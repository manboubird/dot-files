" source $XDG_CONFIG_HOME/vim/vimrc

" ref:
" MacVim-KaoriYaでpyenvのPythonを使う - Qiita https://qiita.com/tmsanrinsha/items/cd2c276f7f1a16aeeaea
let g:python3_host_prog = ${PYENV_HOME} . '/versions/py35.nvim/bin/python3'

" if has('nvim')
  " 2016/05/11 neovim update. ignore NVIM_TUI_ENABLE_TRUE_COLOR
  " Vimのオプションのtermguicolorsに対応されました
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
" endif

" Dein
:source <sfile>:h/init-dein-plugins.vim
runtime! init/**.vim

