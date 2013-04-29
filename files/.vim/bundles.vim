let hasVundle=1
let vundle_readme=expand('~/.vim/bundle/vundle/README.md')
if !filereadable(vundle_readme)
    echo "Installing Vundle.."
    echo ""
    silent !mkdir -p ~/.vim/bundle
    silent !git clone https://github.com/gmarik/vundle ~/.vim/bundle/vundle
    let hasVundle=0
endif
"================================================= 
" Vundle plugin for plugin management 
"=================================================
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'sudo.vim'
Bundle 'vim-ruby/vim-ruby'
Bundle 'derekwyatt/vim-scala'
Bundle 'surround.vim'
Bundle 'xolox/vim-session'
Bundle 'scrooloose/nerdtree'
Bundle 'tomtom/tcomment_vim'
Bundle 'godlygeek/tabular'
Bundle 'tpope/vim-markdown'
Bundle 'thinca/vim-quickrun'
Bundle 'altercation/vim-colors-solarized'

Bundle 'Rainbow-Parenthesis'

" comment out due to collision of gist-vim  
"Bundle 'suan/vim-instant-markdown'

" clojure
Bundle 'tpope/vim-fireplace'
Bundle 'tpope/vim-classpath'
Bundle 'guns/vim-clojure-static'

" screen/tmux sender
Bundle 'jpalardy/vim-slime'
"Bundle 'ervandew/screen'

" database
Bundle 'SQLComplete.vim'
Bundle 'dbext.vim'
Bundle "vim-scripts/SQLUtilities"
Bundle "Align"

" git
if (executable("git"))
  Bundle 'tpope/vim-fugitive'
  Bundle 'mattn/webapi-vim'
  Bundle 'mattn/gist-vim'
endif

" ack
if (executable("ack"))
  Bundle 'mileszs/ack.vim'
endif


" exp
"Bundle 'scrooloose/nerdcommenter'
"Bundle 'LogViewer'
" Bundle 'vcscommand.vim'
" Bundle 'vim-scripts/BlockDiff'
" Bundle 'DirDiff.vim'
" http://nanasi.jp/articles/vim/filtering_vim.html
Bundle 'vim-scripts/Quich-Filter'
Bundle 'ervandew/supertab'
" latest snipmate and its dependencies
" https://github.com/garbas/vim-snipmate
Bundle "MarcWeber/vim-addon-mw-utils"
Bundle "tomtom/tlib_vim"
Bundle "honza/snipmate-snippets"
Bundle "garbas/vim-snipmate"
Bundle "http://bitbucket.org/larsyencken/vim-drake-syntax.git"

if version >= 701
  " http://blog.blueblack.net/item_164/
  Bundle "AutoComplPop"

  Bundle 'scrooloose/syntastic'
endif

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

if hasVundle == 0
    echo "Bundles is not installed. Installing Bundles"
    echo ""
    :BundleInstall
endif

filetype plugin indent on
