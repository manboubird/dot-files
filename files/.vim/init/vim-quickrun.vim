let g:quickrun_no_default_key_mappings = 1
let g:quickrun_config = {}
let g:quickrun_config['hql'] = {
 \ 'command': 'hive',
 \ 'exec': ['%c -S -f %s']}

" does not work below
"vnoremap <silent> <Leader>qh :QuickRun hql<CR>

