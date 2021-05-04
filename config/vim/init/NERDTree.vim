let NERDTreeIgnore = ['\.pyc$']

"let NERDTreeSortOrder = ['\/$', '*', '\.swp$',  '\.bak$', '\~$', '[[-timestamp]]']
let NERDTreeSortOrder = ['\/$', '*', '[[-timestamp]]']

" chdir when root was changed
let g:NERDTreeChDirMode = 2

" NERDTreeをCtrl+eで開けるように設定する - vim - TIL, https://tmg0525.hatenadiary.jp/entry/2017/09/02/091054
nnoremap <silent><C-q> :NERDTreeToggle<CR>
