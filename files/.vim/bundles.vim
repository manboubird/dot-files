"================================================= 
" Vundle plugin for plugin management 
"=================================================
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'sudo.vim'
Bundle 'dbext.vim'
Bundle 'vim-ruby/vim-ruby'
Bundle 'surround.vim'
Bundle 'xolox/vim-session'
Bundle 'scrooloose/nerdtree'
Bundle 'tomtom/tcomment_vim'
Bundle 'vim-scripts/FuzzyFinder'
Bundle 'clones/vim-l9'
Bundle 'tpope/vim-fugitive'
Bundle 'godlygeek/tabular'
Bundle 'mattn/webapi-vim'
Bundle 'scrooloose/syntastic'
Bundle 'tpope/vim-markdown'
Bundle 'mattn/gist-vim'
" comment out due to collision of gist-vim  
"Bundle 'suan/vim-instant-markdown'
Bundle 'thinca/vim-quickrun'
Bundle 'altercation/vim-colors-solarized'
Bundle 'ervandew/screen'

" exp
"Bundle 'scrooloose/nerdcommenter'
"Bundle 'LogViewer'

" vim 7.2+
if version >= 702
  Bundle 'nathanaelkane/vim-indent-guides'

  " http://www.vim.org/scripts/script.php?script_id=1234
  " Bundle 'YankRing.vim'
endif

" vim 7.3+
if version >= 703
  Bundle 'Shougo/vimproc'
  Bundle 'Shougo/vimshell'
  Bundle 'Shougo/neocomplcache'
  Bundle 'Shougo/neocomplcache-snippets-complete'

  " https://github.com/sjl/gundo.vim
  " Bundle 'sjl/gundo.vim'
endif

filetype plugin indent on
