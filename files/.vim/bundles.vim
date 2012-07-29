"================================================= 
" Vundle plugin for plugin management 
"=================================================
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" github repos
Bundle 'gmarik/vundle'
Bundle 'sudo.vim'
Bundle 'scrooloose/nerdtree'
Bundle 'tomtom/tcomment_vim'
Bundle 'tpope/vim-markdown'
Bundle 'suan/vim-instant-markdown'
Bundle 'thinca/vim-quickrun'
Bundle 'altercation/vim-colors-solarized'
Bundle 'ervandew/screen'

" vim 7.2+
if version >= 702
  Bundle 'nathanaelkane/vim-indent-guides'
endif

" vim 7.3+
if version >= 703
  Bundle 'Shougo/vimproc'
  Bundle 'Shougo/vimshell'
  Bundle 'Shougo/neocomplcache'
  Bundle 'Shougo/neocomplcache-snippets-complete'
endif

filetype plugin indent on
