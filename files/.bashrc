EDITOR=/usr/bin/vim

##
# LANG settings
#
export LANG=ja_JP.UTF-8
export JLESSCHARSET=utf-8
##

# #
# JAVA setting
#
# to prevent garbled characters in lein repl
#export _JAVA_OPTIONS=-Dfile.encoding=UTF-8 
# Dev settings should be in .barshrc.local
#export JAVA_OPTS="-Xmx768m"
##

PATH=$HOME/local/bin:$PATH
##
# etc
#
if tty -s ; then
  # show [username@hostname:workspace]
  PS1='\u@\h:\w\$ '
  # disable C-s 
  stty stop undef
fi
##

##
# functions
#
# start a screen with screen name
function scrn() { /usr/bin/screen -t "$@"; }
# find on git/svn managed directory.
function find-git() { find $1 | grep -v '.git'; }
function find-svn() { find $1 | grep -v '.svn'; }
#

# os specific setting
case "${OSTYPE}" in
  # Mac(Unix)
  darwin*)
    [ -f ~/.dot-files/files/.os-types/.bashrc.osx ] && source ~/.dot-files/files/.os-types/.bashrc.osx
    ;;
  # Linux
  linux*)
    [ -f ~/.dot-files/files/.os-types/.bashrc.linux ] && source ~/.dot-files/files/.os-types/.bashrc.linux
    ;;
esac

# environment specific settings such as export.
[ -f ~/.bashrc.local ] && source ~/.bashrc.local

##
# Load alias files. Some need export env vars.
# To apply all aliases, add below into .bashrc.local  
#
#    DOT_FILES_ALIAS_FILES=(ls ~/.dot-files/files/.aliases/)
#
if [ -z "${DOT_FILES_ALIAS_FILES}" ]; then 
  DOT_FILES_ALIAS_FILES=(commands hadoop pdsh)
fi
for file in ${DOT_FILES_ALIAS_FILES[@]}; do
  source ~/.aliases/$file
done

