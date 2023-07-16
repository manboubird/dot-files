set nocompatible

let $CACHE = expand('~/.cache')
if !isdirectory($CACHE)
  call mkdir($CACHE, 'p')
endif

if &runtimepath !~# '/dein.vim'
  let s:dein_dir = fnamemodify('dein.vim', ':p')
  if !isdirectory(s:dein_dir)
    let s:dein_dir = $CACHE . '/dein/repos/github.com/manboubird/dein.vim'
    if !isdirectory(s:dein_dir)
      execute '!git clone https://github.com/manboubird/dein.vim' s:dein_dir
    endif
  endif
  execute 'set runtimepath^=' . substitute(
        \ fnamemodify(s:dein_dir, ':p') , '[/\\]$', '', '')
endif


" TOML file for plugin list
let g:rc_dir    = expand('~/.config/nvim/rc')
let s:toml      = g:rc_dir . '/dein.toml'
let s:lazy_toml = g:rc_dir . '/dein-lazy.toml'


if dein#load_state($CACHE . '/dein')
  call dein#begin($CACHE . '/dein')

  call dein#load_toml(s:toml, {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

if has('filetype')
  filetype plugin indent on
endif
if has('syntax')
  syntax on
endif

if dein#check_install()
  call dein#install()
endif
