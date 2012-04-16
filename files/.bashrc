EDITOR=/usr/bin/vim
export LANG=ja_JP.UTF-8
export JLESSCHARSET=japanese

# disable C-s 
stty stop undef

# screen name assgnment 
function scrn() { /usr/bin/screen -t "$@"; }

. ~/.aliases/commands
. ~/.aliases/hadoop
