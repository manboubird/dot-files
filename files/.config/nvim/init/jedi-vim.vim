"""""
" Disable dynamic loading settings
" Ref. https://github.com/manboubird/homebrew-splhack
"
" let s:python2home = $PYENV_ROOT . '/versions/' . $PYENV_PYTHON2_VERSION
" let s:python2dll  = $PYENV_ROOT . '/versions/' . $PYENV_PYTHON2_VERSION . '/lib/libpython2.7.dylib'
" let s:python3home = $PYENV_ROOT . '/versions/' . $PYENV_PYTHON3_VERSION
" let s:python3dll  = $PYENV_ROOT . '/versions/' . $PYENV_PYTHON3_VERSION .'/lib/libpython3.5m.dylib'
"
" if executable(s:python2dll)
"   let &pythondll = s:python2dll
"   let $PYTHONHOME = s:python2home
"   execute 'python import sys'
" endif
"
" if executable(s:python3dll)
"   let &pythonthreedll = s:python3dll
"   let $PYTHONHOME = s:python3home
"   execute 'python3 import sys'
" endif
"
""""""

let g:jedi#use_tabs_not_buffers = 1                " 補完で次の候補に進むときにtabを使えるという設定にしたつもりですができませんでした。
let g:jedi#popup_select_first = 0                  " 1個目の候補が入力されるっていう設定を解除
let g:jedi#popup_on_dot = 0                        " .を入力すると補完が始まるという設定を解除
let g:jedi#goto_command = "<leader>d"
let g:jedi#goto_assignments_command = "<leader>g"
let g:jedi#goto_definitions_command = ""
let g:jedi#documentation_command = "K"
let g:jedi#usages_command = "<leader>n"
let g:jedi#rename_command = "<leader>R"               " quick-runと競合しないように大文字Rに変更. READMEだと<leader>r
autocmd FileType python setlocal completeopt-=preview " ポップアップを表示しない
