" let g:quickrun_no_default_key_mappings = 1  " disable default <Leader>, keybinding

" move output buffer after running and split verticall
let g:quickrun_config = {
 \  "_" : { "outputter/buffer/into" : 1,
 \ 'split': 'vertical'},} 
set splitright

" hive settings
let g:quickrun_config['hql'] = {
 \ 'command': 'hive',
 \ 'exec': ['%c -S -f %s']}

" does not work below
"vnoremap <silent> <Leader>qh :QuickRun hql<CR>

