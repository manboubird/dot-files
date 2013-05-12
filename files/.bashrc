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

# os specific setting
case "${OSTYPE}" in
  # Mac(Unix)
  darwin*) [ -f ~/.dot-files/files/.os-types/.bashrc.osx ] && source ~/.dot-files/files/.os-types/.bashrc.osx ;;
  # Linux
  linux*) [ -f ~/.dot-files/files/.os-types/.bashrc.linux ] && source ~/.dot-files/files/.os-types/.bashrc.linux ;;
esac

# environment specific settings such as export.
[ -f ~/.bashrc.local ] && source ~/.bashrc.local

# setup with local settings
[ -f ~/.bashrc.after ] && source ~/.bashrc.after
[ -f ~/.bashrc.after.local ] && source ~/.bashrc.after.local

