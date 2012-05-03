EDITOR=/usr/bin/vim
export LANG=ja_JP.UTF-8
export JLESSCHARSET=japanese

# to prevent garbled characters in lein repl
export _JAVA_OPTIONS=-Dfile.encoding=UTF-8 
# for cascalog on repl
export JAVA_OPTS="-Xmx768m"

# disable C-s 
stty stop undef

# start a screen with screen name
function scrn() { /usr/bin/screen -t "$@"; }

# find on git/svn managed directory.
function git-find() { find $1 | grep -v '.git'; }
function svn-find() { find $1 | grep -v '.svn'; }


. ~/.aliases/commands
. ~/.aliases/hadoop
