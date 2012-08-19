"================================================= 
" Vundle plugin for plugin management 
"=================================================
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'sudo.vim'
Bundle 'vim-ruby/vim-ruby'
Bundle 'surround.vim'
Bundle 'xolox/vim-session'
Bundle 'scrooloose/nerdtree'
Bundle 'tomtom/tcomment_vim'
Bundle 'godlygeek/tabular'
Bundle 'scrooloose/syntastic'
Bundle 'tpope/vim-markdown'
Bundle 'thinca/vim-quickrun'
Bundle 'altercation/vim-colors-solarized'
Bundle 'ervandew/screen'

" comment out due to collision of gist-vim  
"Bundle 'suan/vim-instant-markdown'

" database
Bundle 'SQLComplete.vim'
Bundle 'dbext.vim'
Bundle "vim-scripts/SQLUtilities"
Bundle "Align"

" git
Bundle 'tpope/vim-fugitive'
Bundle 'mattn/webapi-vim'
Bundle 'mattn/gist-vim'

" exp
"Bundle 'scrooloose/nerdcommenter'
"Bundle 'LogViewer'
" Bundle 'vcscommand.vim'
" http://nanasi.jp/articles/vim/filtering_vim.html
Bundle 'vim-scripts/Quich-Filter'
Bundle 'AutoClose'
Bundle 'ervandew/supertab'
" latest snipmate and its dependencies
" https://github.com/garbas/vim-snipmate
Bundle "MarcWeber/vim-addon-mw-utils"
Bundle "tomtom/tlib_vim"
Bundle "honza/snipmate-snippets"
Bundle "garbas/vim-snipmate"
" http://blog.blueblack.net/item_164/
Bundle "AutoComplPop"

" vim 7.2+
if version >= 702
  Bundle 'nathanaelkane/vim-indent-guides'
  Bundle 'ddclones/vim-l9'
  Bundle 'vim-scripts/FuzzyFinder'

  " https://github.com/Lokaltog/vim-easymotion
  Bundle 'Lokaltog/vim-easymotion'

  " http://www.vim.org/scripts/script.php?script_id=1234
  " Bundle 'YankRing.vim'
endif

" vim 7.3+
if version >= 703
  " Bundle 'Shougo/vimshell'
  " turn off for snipmate
  " Bundle 'Shougo/vimproc'
  " Bundle 'Shougo/neocomplcache'
  " Bundle 'Shougo/neocomplcache-snippets-complete'

  " https://github.com/sjl/gundo.vim
  " Bundle 'sjl/gundo.vim'
endif

filetype plugin indent on
