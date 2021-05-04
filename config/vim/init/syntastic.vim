set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_mode_map = { 'mode': 'active',
                           \ 'active_filetypes': ['ruby','puppet','json','sh','yaml','perl','javascript','python'],
                           \ 'passive_filetypes': ['html'] }

" python
let g:syntastic_python_checkers = ["mypy","flake8"]
" if (executable("flake8"))
"   let g:syntastic_python_checkers = ["flake8"]
" endif
if (executable("rstcheck"))
  let g:syntastic_rst_checkers = ['rstcheck']
endif
" let g:syntastic_javascript_checkers = ['eslint']
" let g:syntastic_javascript_eslint_exec = 'eslint_d'

