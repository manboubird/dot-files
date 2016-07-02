" Prompt for a command to run
map <Leader>tp :VimuxPromptCommand<CR>
 
" Send last command 
map <Leader>tl :VimuxRunLastCommand<CR>

" If text is selected, save it in the v buffer and send that buffer it to tmux
vmap <Leader>ts "vy :call VimuxRunCommand(@v . "\n", 0)<CR>
 
" Select current paragraph and send it to tmux
nmap <Leader>ts vip<LocalLeader>ts<CR>
