#
# ~/.bashrc
#
# custom alias

[[ $- != *i* ]] && return

colors() {
	local fgc bgc vals seq0

	printf "Color escapes are %s\n" '\e[${value};...;${value}m'
	printf "Values 30..37 are \e[33mforeground colors\e[m\n"
	printf "Values 40..47 are \e[43mbackground colors\e[m\n"
	printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

	# foreground colors
	for fgc in {30..37}; do
		# background colors
		for bgc in {40..47}; do
			fgc=${fgc#37} # white
			bgc=${bgc#40} # black

			vals="${fgc:+$fgc;}${bgc}"
			vals=${vals%%;}

			seq0="${vals:+\e[${vals}m}"
			printf "  %-9s" "${seq0:-(default)}"
			printf " ${seq0}TEXT\e[m"
			printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
		done
		echo; echo
	done
}

[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

# Change the window title of X terminals
case ${TERM} in
	xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
		;;
	screen*)
		PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
		;;
esac

use_color=true

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.  Use internal bash
# globbing instead of external grep binary.
safe_term=${TERM//[^[:alnum:]]/?}   # sanitize TERM
match_lhs=""
[[ -f ~/.dir_colors   ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs}    ]] \
	&& type -P dircolors >/dev/null \
	&& match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

if ${use_color} ; then
	# Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
	if type -P dircolors >/dev/null ; then
		if [[ -f ~/.dir_colors ]] ; then
			eval $(dircolors -b ~/.dir_colors)
		elif [[ -f /etc/DIR_COLORS ]] ; then
			eval $(dircolors -b /etc/DIR_COLORS)
		fi
	fi

	if [[ ${EUID} == 0 ]] ; then
		PS1='\[\033[01;31m\][\h\[\033[01;36m\] \W\[\033[01;31m\]]\$\[\033[00m\] '
	else
		PS1='\[\033[01;32m\][\u@\h\[\033[01;37m\] \W\[\033[01;32m\]]\$\[\033[00m\] '
	fi

	alias ls='ls --color=auto'
	alias grep='grep --colour=auto'
	alias egrep='egrep --colour=auto'
	alias fgrep='fgrep --colour=auto'
else
	if [[ ${EUID} == 0 ]] ; then
		# show root@ when we don't have colors
		PS1='\u@\h \W \$ '
	else
		PS1='\u@\h \w \$ '
	fi
fi

unset use_color safe_term match_lhs sh

alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias np='nano -w PKGBUILD'
alias more=less

xhost +local:root > /dev/null 2>&1

complete -cf sudo

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize

shopt -s expand_aliases

# export QT_SELECT=4

# Enable history appending instead of overwriting.  #139609
shopt -s histappend

#
# # ex - archive extractor
# # usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}
# colors and shit
# Formatting
ResetColor="\e[0m"
Bold="\e[1m"
Dim="\e[2m"
Italic="\e[3m"
Underline="\e[4m"
Blink="\e[5m"
InvertColors="\e[7m"
Hidden="\e[8m"
Strikethrough="\e[9m"

# Regular colors
Black="\e[30m"
Red="\e[31m"
Green="\e[32m"
Yellow="\e[33m"
Blue="\e[34m"
Purple="\e[35m"
Cyan="\e[36m"
White="\e[37m"

# Background
OnBlack="\e[40m"
OnRed="\e[41m"
OnGreen="\e[42m"
OnYellow="\e[43m"
OnBlue="\e[44me"
OnPurple="\e[45m"
OnCyan="\e[46m"
OnWhite="\e[47me"

# High intensity
IntenseBlack="\e[90m"
IntenseRed="\e[91m"
IntenseGreen="\e[92m"
IntenseYellow="\e[93m"
IntenseBlue="\e[94m"
IntensePurple="\e[95m"
IntenseCyan="\e[96m"
IntenseWhite="\e[97m"

# High intensity background
OnIntenseBlack="\e[100m"
OnIntenseRed="\e[101m"
OnIntenseGreen="\e[102m"
OnIntenseYellow="\e[103m"
OnIntenseBlue="\e[104m"
OnIntensePurple="\e[105m"
OnIntenseCyan="\e[106m"
OnIntenseWhite="\e[107m"

# Variables
Time24hhmmss="\t"
PathShort="\W"
PathFull="\w"
NewLine="\n"
Username="\u"
MachineName="\h"

# Actions
Alert="\a"

function make_ps1() {
	local ErrorCode=$?




	# First line
	PS1="$Bold$White┌─"

	# If there is an error code, print it in a box
	if [ $ErrorCode != 0 ] ; then
		PS1=$PS1"[$Red$ErrorCode$Bold$White]─"
	fi

	# Print the username and system name
	PS1=$PS1"["
	# If we are root, show the username as red
	if [ "$(whoami)" == 'root' ]; then
		PS1=$PS1"$Red"
	else
		PS1=$PS1"$Yellow"
	fi
	PS1=$PS1$Username$Bold$White@$IntenseCyan$MachineName$Bold$White"]─"

	# Print the working directory, highlighting the git root
	PS1=$PS1"[$Green"
	local Path=$PWD
	if [ "${Path#$HOME}" != "$Path" ] ; then
		Path="~${Path#$HOME}"
	fi

	if git branch &>/dev/null ; then
		local GitRoot=$(git rev-parse --show-toplevel)
		if [ "${GitRoot#$HOME}" != "$GitRoot" ] ; then
			GitRoot="~${GitRoot#$HOME}"
		fi
		PS1=$PS1$(dirname $GitRoot)"/"
		PS1=$PS1$Purple$(basename $GitRoot)
		PS1=$PS1$Green${Path#$GitRoot}
	else
		PS1=$PS1$Green$Path
	fi
	PS1=$PS1$Bold$White"]"

	# Print the git branch if it exists
	if git branch &>/dev/null ; then
		PS1=$PS1"─["
		if git status --porcelain | grep -q "\\S" ; then
			# There are changes to working tree
			PS1=$PS1$Purple
		else
			# There is nothing to commit
			PS1=$PS1$Green
		fi
		PS1=$PS1$(git branch 2>/dev/null | grep '*' | sed 's/* \(.*\)/\1/')$Bold$White"]"
	fi
	PS1=$PS1"\n"




	# Second line
	PS1=$PS1"$Bold$White└──> $ResetColor"

	export PS1
}

function make_ps2() {
	PS2="$Bold$White└──> $ResetColor"
	export PS2
}

function make_ps3() {
	PS3="$Bold$White> $ResetColor"
	export PS3
}

function make_ps4() {
	PS4="$Bold$White+ $ResetColor"
	export PS4
}

function make_prompts() {
	make_ps1
	make_ps2
	make_ps3
	make_ps4
}


function set_file_system_node_colors() {
	# directory
	LS_COLORS=$LS_COLORS'di=0;37:'

	# file
	LS_COLORS=$LS_COLORS'fi=0;0:'

	# symbolic link
	LS_COLORS=$LS_COLORS'ln=0;32:'

	# symbolic link pointing to a non-existent file (orphan)
	LS_COLORS=$LS_COLORS'or=01;32:'

	# executable
	LS_COLORS=$LS_COLORS'ex=0;1:'

	export LS_COLORS
}

function do_stuff() {
	make_prompts
	set_file_system_node_colors
}

PROMPT_COMMAND=do_stuff

alias ls='ls --color -F'
