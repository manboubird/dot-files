EDITOR=/usr/bin/vim
export LANG=ja_JP.UTF-8
export JLESSCHARSET=japanese

# to prevent garbled characters in lein repl
export _JAVA_OPTIONS=-Dfile.encoding=UTF-8 

# disable C-s 
stty stop undef

# screen name assgnment 
function scrn() { /usr/bin/screen -t "$@"; }

. ~/.aliases/commands
. ~/.aliases/hadoop
