"================================================= 
" Vundle plugin for plugin management 
" First vim invocation command with:
"   vim -u ~/.vim/bundles.vim +BundleInstall +q
"=================================================
:source <sfile>:h/.vim/bundles.vim

"================================================= 
" qfixapp
"=================================================
set runtimepath+=h/.vim/bundle/qfixapp

" キーマップリーダー
let QFixHowm_Key = ','

" howm_dirはファイルを保存したいディレクトリを設定
let howm_dir             = '~/howm'
let howm_filename        = '%Y/%m/%Y-%m-%d-%H%M%S.txt'
let howm_fileencoding    = 'utf-8'
let howm_fileformat      = 'unix'

"=================================================
" neocomplcache
"=================================================

let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_quick_match = 1
let g:NeoComplCache_EnableCamelCaseCompletion = 1
let g:NeoComplCache_EnableUnderbarCompletion = 1

highlight Pmenu ctermbg=8
highlight PmenuSel ctermbg=1
highlight PmenuSbar ctermbg=0

imap <C-k> <Plug>(neocomplcache_snippets_expand)
smap <C-k> <Plug>(neocomplcache_snippets_expand)

"=================================================
" Others
"=================================================


set nocompatible

set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif

set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
"set incsearch		" do incremental searching

map Q gq

if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  augroup END

  set showmatch
  set tabstop=2
  set shiftwidth=2
  set expandtab
  "set tags=~/ruby/tags,./tags,/var/www/html/trust-dev/tags
  "set tags=~/usr/local/src/kagemai-0.8.6/kagemai_tags
  set nohlsearch
  set hidden
  source $VIMRUNTIME/macros/matchit.vim
  syntax on
  set dictionary+=$VIMRUNTIME/syntax/ruby.vim
  set nobackup
  set nowritebackup
  set backupdir=/var/tmp/vimbackup
  filetype on
  filetype indent on 
  filetype plugin on
  "set viewdir=~/.vim/view
  "au BufWritePost * mkview
  "autocmd BufReadPost * loadview
  au FileType ruby set ts=2 sw=2 expandtab
  set nofoldenable
  "au FileType perl set foldmethod=indent
  "autocmd Filetype ruby source ~/.vim/ruby-macros.vim
  "autocmd Filetype ruby set foldmethod=indent
  "map <unique> <silent> <Leader>f <Plug>SimpleFold_Foldsearch
else
  set autoindent		" always set autoindenting on
endif " has("autocmd")

set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P "show character code and new line character on status
set laststatus=2 "always appear status line

highlight Folded ctermfg=6 ctermbg=0
highlight FoldColumn ctermfg=6 ctermbg=0

"## highlight for completion
highlight Pmenu    ctermbg=darkgray ctermfg=white
highlight PmenuSel ctermbg=lightcyan ctermfg=black cterm=bold,underline
highlight PmenuSbar ctermfg=0 ctermbg=0

set wildmenu
set nrformats-=octal
"au FileType ruby setlocal path+=/usr/local/lib/ruby/1.8 suffixesadd+=.rb
au FileType ruby setlocal path+=/usr/lib/ruby/1.8 suffixesadd+=.rb

augroup ShebangAutowrite
  autocmd BufNewFile *.py 0put =\"#!/usr/bin/env python\<nl># -*- coding: iso-8859-15 -*-\<nl>\"|$
  autocmd BufNewFile *.rb 0put =\"#!/usr/bin/ruby\"|$
  autocmd BufNewFile *.pl 0put =\"#!/usr/bin/perl\"|$
  autocmd BufNewFile *.sh 0put =\"#!/bin/bash\"|$
  autocmd BufNewFile *.tex 0put =\"%&plain\<nl>\"|$
  autocmd BufNewFile *.\(cc\|hh\) 0put =\"//\<nl>// \".expand(\"<afile>:t\").\" -- \<nl>//\<nl>\"|2|start!
augroup END

"let cmd = ":%! irb -f --prompt simple "
function! Filetype_eval_vsplit() range
  let lang = &ft
  let cmd = ":%! " . lang
  let src = tempname()
  let dst = "/tmp/" . $USER . "_Output"
  setlocal splitright
  silent execute ": " . a:firstline . "," . a:lastline . "w " . src
  execute ":pclose!" | execute ":vsplit " . dst
  execute ":redraw!" | execute ":set pvw" |  wincmd l
  silent execute cmd . " " . src . " 2>&1 "
  setlocal buftype=nofile | setlocal autoread | setlocal noswapfile     
  execute "setlocal syntax=" . lang
  wincmd h
endfunction

" turn off ',r' for vimClosure
"vmap <silent> ,r       mz:call Filetype_eval_vsplit()<CR>`z
"nmap <silent> ,r   mzggVG:call Filetype_eval_vsplit()<CR>`z
nmap <silent> ,p   mz^ialert(<ESC>A)<ESC>`z
nmap <silent> ,q   0iquit()<ESC>
nmap <silent> ,d   :%s![“”]!"!g<CR>
nmap <silent> "    mzbi"<ESC>ea"<ESC>`z

nmap <silent> ,c <C-W>l:bw<CR>
nmap <silent> ,s :source $HOME/.vimrc<CR>

" Quick Fix
autocmd FileType perl,cgi :compiler perl
autocmd FileType ruby     :compiler ruby
nmap <silent> ,m :!clear<CR>:make -c %<CR>

" for vimClojure
syntax on
filetype plugin indent on
let clj_highlight_builtins = 1
let clj_highlight_contrib = 1
let clj_paren_rainbow = 1
let clj_want_gorilla = 1
let vimclojure#NailgunClient = '/usr/local/vimclojure/bin/ng'
" let maplocalleader = '.'

