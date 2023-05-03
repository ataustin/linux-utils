# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
# force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    export PS1="${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\W \[\033[1;33m\][\$(git branch 2>/dev/null | grep '^*' | colrm 1 2)] \[\033[00m\]\$ "
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# DAD JOKE
echo ""
echo ">>> INCOMING DAD JOKE <<<"
curl -H "Accept: text/plain" https://icanhazdadjoke.com/
echo ""

# ALIASES
# list files
alias ll='ls -lh --color=auto'
alias la='ls -alh --color=auto'

# git
alias gl='git log --pretty=format:"%h %s" --graph'
alias gb='git branch --all'
alias groot='cd $(git rev-parse --show-toplevel); ll'
alias push-this='git push origin $(git rev-parse --abbrev-ref HEAD)'

# directory shortcuts
alias repos='cd $HOME/repos; ll'

# pretty print path
alias listpath='echo $PATH | tr : "\n"'

# .bashrc stuff
alias edbrc='nano $HOME/.bashrc'
alias reload='source $HOME/.bashrc'

# safe file movement
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# easy navigation
alias ..='cd ..; pwd'
alias ...='cd ../..; pwd'
alias ....='cd ../../..; pwd'

# if linux time is out of sync
alias fix-time='sudo hwclock -s'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# FUNCTIONS
function mkcd(){
    mkdir $1;
    cd $1;
}

function cl(){
    cd $1;
    ll;
    pwd;
}

# file browser
function browse(){
    if [ $# -eq 0 ]; then
        python3 -m http.server 8000;
    else
        python3 -m http.server $1;
    fi
}

# size of a directory on disk
function howbigis(){
    du -sh $1;
}

# git functions
function gcheck(){
    git checkout $1;
}

function newbranch(){
    git checkout -b $1;
}

function gpush(){
    git push $1 $2;
}

function gs(){
    git status;
}

function git_trim(){
    git fetch;
    if [[ `git branch --merged | egrep -v "(^\*|^master$|^dev$|^gh-pages$)"` = '' ]]; then
        echo "No stale branches to delete";
    else
        echo "Remote branch pruning...";
        git remote prune origin;
        echo "Local branch pruning...";
        git branch --merged | egrep -v "(^\*|^master$|^dev$|^gh-pages$)" | xargs git branch -d;
    fi
}

function update-repo(){
    git checkout master;
    git pull origin master;
    git_trim;
    git pull origin master;
    echo "";
    echo "git branch";
    git branch;
}

function csv-diff(){
    git diff --word-diff-regex=[^[:space:],]+ $1 $2
}


# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# ASCII art at startup
# source $HOME/repos/ascii-art/aperture.sh

