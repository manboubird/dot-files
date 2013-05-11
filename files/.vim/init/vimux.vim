" Prompt for a command to run
map <LocalLeader>vp :VimuxPromptCommand<CR>
 
" If text is selected, save it in the v buffer and send that buffer it to tmux
vmap <LocalLeader>vs "vy :call VimuxRunCommand(@v . "\n", 0)<CR>
 
" Select current paragraph and send it to tmux
nmap <LocalLeader>vs vip<LocalLeader>vs<CR>
