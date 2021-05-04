" https://github.com/lifepillar/vim-solarized8

" True color support with (iTerm2 + tmux + Vim) | Tom Lankhorst, https://qiita.com/izumin5210/items/5b7f4c01fb6fe6064a05
"
" set termguicolors
" let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
" let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

if has('gui_running')
  set background=light
else
  set background=dark
endif
colorscheme solarized8

