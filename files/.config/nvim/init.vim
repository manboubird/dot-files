set nocompatible

if has('filetype')
  filetype plugin indent on
endif
if has('syntax')
  syntax on
endif

call plug#begin()

" Plug 'nvie/vim-flake8'
Plug 'davidhalter/jedi-vim'
Plug 'jmcantrell/vim-virtualenv'
Plug 'lambdalisue/vim-pyenv'
Plug 'tpope/vim-fireplace'
Plug 'tpope/vim-classpath'
" Plug 'guns/vim-clojure-static'
Plug 'vim-scripts/paredit.vim'
" Plug 'liquidz/lein-vim'
Plug 'kien/rainbow_parentheses.vim'
" Plug 'derekwyatt/vim-scala'
Plug 'pangloss/vim-javascript'
" Plug 'mxw/vim-jsx'
" Plug 'manboubird/dein.vim'
Plug 'vim-scripts/sudo.vim'
Plug 'lepture/vim-jinja'
Plug 'vim-ruby/vim-ruby'
Plug 'vim-scripts/surround.vim'
Plug 'xolox/vim-misc'
Plug 'xolox/vim-session'
Plug 'preservim/nerdtree'
Plug 'tomtom/tcomment_vim'
Plug 'godlygeek/tabular'
Plug 'preservim/vim-markdown'
Plug 'thinca/vim-quickrun'
Plug 'altercation/vim-colors-solarized'
Plug 'bling/vim-airline'
" Plug 'suan/vim-instant-markdown'
Plug 'Rykka/InstantRst'
Plug 'vim-scripts/Quich-Filter'
Plug 'ervandew/supertab'
Plug 'jpalardy/vim-slime'
Plug 'epeli/slimux'
Plug 'wannesm/wmgraphviz.vim'
Plug 'scrooloose/syntastic'
Plug 'Lokaltog/vim-easymotion'
Plug 'regedarek/ZoomWin'
Plug 'myusuf3/numbers.vim'
Plug 'mileszs/ack.vim'
Plug 'rking/ag.vim'
Plug 'majutsushi/tagbar'
Plug 'yuratomo/w3m.vim'
Plug 'aklt/plantuml-syntax'
Plug 'tpope/vim-fugitive'
Plug 'mattn/webapi-vim'
Plug 'airblade/vim-gitgutter'
" Plug 'mattn/gist-vim'
Plug 'lambdalisue/vim-gista'
Plug 'vim-scripts/SQLComplete.vim'
Plug 'vim-scripts/dbext.vim'
Plug 'vim-scripts/SQLUtilities'
Plug 'vim-scripts/Align'
Plug 'junegunn/vim-easy-align'
Plug 'exu/pgsql.vim'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'honza/vim-snippets'
Plug 'garbas/vim-snipmate'
" Plug 'http://bitbucket.org/larsyencken/vim-drake-syntax.git'

call plug#end()

runtime! init/**.vim
