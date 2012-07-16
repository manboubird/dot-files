"================================================= 
" Vundle plugin for plugin management 
"=================================================
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" github repos
Bundle 'gmarik/vundle'
Bundle 'scrooloose/nerdtree'
Bundle 'tomtom/tcomment_vim'
Bundle 'tpope/vim-markdown'
Bundle 'suan/vim-instant-markdown'
Bundle 'thinca/vim-quickrun'

if v:version >= 720 
  Bundle 'nathanaelkane/vim-indent-guides'
endif

if v:version >= 730 
  Bundle 'nathanaelkane/vim-indent-guides'
  Bundle 'Shougo/vimproc'
  Bundle 'Shougo/vimshell'
  Bundle 'Shougo/neocomplcache'
  Bundle 'Shougo/neocomplcache-snippets-complete'
endif

filetype plugin indent on
