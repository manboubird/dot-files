let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1
let g:gist_post_private = 1
let g:gist_browser_command = 'w3m %URL%'

if has("unix")
  let s:uname = system("uname")
  if s:uname == "Darwin"
    let g:gist_clip_command = 'pbcopy'
  endif
endif
