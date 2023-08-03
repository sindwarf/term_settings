#!/bin/bash
# ┌────────────────────────┐
# │     .bashrc setup      │
# └────────────────────────┘
# git config --global alias.hist "log --pretty=format:'%C(yellow)[%ad]%C(reset) %C(green)[%h]%C(reset) | %C(red)%s %C(bold red){{%an}}%C(reset) %C(blue)%d%C(reset)' --graph --date=short"
# Color Variables for bash
txtblk="\[\033[0;30m\]" # Black - Regular
txtred="\[\033[0;31m\]" # Red
txtgrn="\[\033[0;32m\]" # Green
txtylw="\[\033[0;33m\]" # Yellow
txtblu="\[\033[0;34m\]" # Blue
txtpur="\[\033[0;35m\]" # Purple
txtcyn="\[\033[0;36m\]" # Cyan
txtwht="\[\033[0;37m\]" # White
# Bold Colors
bldblk="\[\033[1;30m\]" # Black - Bold
bldred="\[\033[1;31m\]" # Red
bldgrn="\[\033[1;32m\]" # Green
bldylw="\[\033[1;33m\]" # Yellow
bldblu="\[\033[1;34m\]" # Blue
bldpur="\[\033[1;35m\]" # Purple
bldcyn="\[\033[1;36m\]" # Cyan
bldwht="\[\033[1;37m\]" # White
# Underline Colors
unkblk="\[\033[4;30m\]" # Black - Underline
undred="\[\033[4;31m\]" # Red
undgrn="\[\033[4;32m\]" # Green
undylw="\[\033[4;33m\]" # Yellow
undblu="\[\033[4;34m\]" # Blue
undpur="\[\033[4;35m\]" # Purple
undcyn="\[\033[4;36m\]" # Cyan
undwht="\[\033[4;37m\]" # White
# Background Colors
bakblk="\[\033[40m\]"   # Black - Background
bakred="\[\033[41m\]"   # Red
badgrn="\[\033[42m\]"   # Green
bakylw="\[\033[43m\]"   # Yellow
bakblu="\[\033[44m\]"   # Blue
bakpur="\[\033[45m\]"   # Purple
bakcyn="\[\033[46m\]"   # Cyan
bakwht="\[\033[47m\]"   # White
txtrst="\[\033[00m\]"    # Text Reset

main() {
    version=$(get_linux_version)

    # Source settings that are similar between all Linux versions
    general_setup

    source /tools/modules/gitpath/gitpathbin.sh 
    module load mentor
    module load altera

    # Source unique version settings
    if [[ "$version" == "Raspbian" ]]; then
        raspian_setup

    elif [[ "$version" == "WindowsUbuntu" ]]; then
        windows_setup

    elif [[ "$version" == "Manjaro" ]]; then
        manjaro_setup

    elif [[ "$version" == "Ubuntu" ]]; then
        [ -z "$TMUX" ] && exec tmux -f ~/.term_settings/tmux.conf

        # Clear terminal using "Ctrl + l"
        bind '"\C-l":"\" \" 2>/dev/null; clear\n"'
    
    elif [[ ("$version" == "Fedora") || ("$version" == "CentOS") ]]; then
        fedora_setup

    fi
}

function get_linux_version() {
    architecture=$(uname -m)

    # Check if OS is run on Windows
    if [ -d "/mnt/c/Users" ]; then
        echo "WindowsUbuntu"

    elif [[ $architecture == "armv7l" ]]; then
        echo "Raspbian"

    elif [[ $(lsb_release -d | grep Manjaro) ]]; then
        echo "Manjaro"

    elif [[ $(lsb_release -d | grep Ubuntu) ]]; then
        echo "Ubuntu"

    elif [[ $(lsb_release -d | grep Fedora) ]]; then
        echo "Fedora"
    
    elif [[ $(lsb_release -d | grep CentOS) ]]; then
        echo "CentOS"

    fi
}

function general_setup() {
    # Source external bash files before PS1 for git branch name
    source ~/.term_settings/bash_scripts/git-completion.bash
    source ~/.term_settings/bash_scripts/format.bash
    source ~/.term_settings/bash_scripts/dir-recall.bash
    
    # PS1='\[\033[01;32m\]\u\[\033[00m\]@\[\033[01;36m\]\h\[\033[01; 34m\] \w\[\033[01;33m\]$(__git_ps1)\[\033[01;35m\] $\[\033[00m\] '
    PS1="$txtcyn\u$bldblu@$bldwht\h$bldgrn \w$bldblu\$(__git_ps1)$bldwht \$ "
    # Turn on parallel history
    shopt -s histappend
    # Turn on checkwinsize
    shopt -s checkwinsize

    # Clipboard piping
    alias "c=xclip"
    alias "v=xclip -o"
    alias "cs=xclip -selection clipboard"
    alias "vs=xclip -o -selection clipboard"

    # Directory aliasing
    alias ls='ls --color=auto'
    alias ll='ls -alF'
    alias lla='ls -la'
    alias la='ls -A'
    alias l='ls -CF'
    alias lslarge='find -type f -exec ls -s {} \; | sort -n -r | head -5 | pv'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'

    # General directory/file locations
    alias .b=". ~/.bashrc; clear"
    alias d='nemo . &'
    alias e='nemo . &'
    alias bashrc='code ~/.bashrc'
    alias vimrc='vim ~/.vimrc'

    # Exporting variables
    export GTEST_COLOR=1
    # export TERM=xterm-256color # Colors for vim
    export TRASH="$HOME/.trash"; mkdir -p $TRASH
    export EDITOR=/usr/bin/vim

    # Path 
    export QT_QPA_PLATFORMTHEME=gtk2
    export PATH="$HOME/.local/apps:$PATH"
    export PATH="$HOME/.local/apps/flutter/bin:$PATH"

    # Allow the terminal to open default programs
    alias open="xdg-open"
    alias default="xdg-open"

    # Redraw unreadable colors for 777 directories
    LS_COLORS="$LS_COLORS:ow=100;30"
    export LS_COLORS
}

function raspian_setup() {
    return
}

function windows_setup() {
    # export DISPLAY=:0
    return
}

function manjaro_setup() {
    source ~/.term_settings/bash_scripts/git-completion-arch.bash
    if [[ ! $TMUX ]]; then
        exec tmux -f ~/.term_settings/tmux.conf
    fi
}

function fedora_setup() {
    . ~/.term_settings/git-prompt-fedora.sh
    
    if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ] && ! shopt -q login_shell; then
        exec tmux -f ~/.term_settings/tmux.conf
    fi
   # [[ $TERM != "screen" ]] && exec tmux -f ~/.term_settings/tmux.conf
    
    # Clear terminal using "Ctrl + l"
    bind '"\C-l":"\" \" 2>/dev/null; clear\n"'
}

# ┌────────────────────────┐
# │       Functions        │
# └────────────────────────┘
function validate_Y_n() {
    typeset ans
    typeset valid=0
    while (($valid == 0)); do
        read ans
        case $ans in
        yes | Yes | Y | y | "")
            echo TRUE
            valid=1
            ;;

        [nN][oO] | n | N)
            valid=1
            ;;

        *) echo "Answer (Y/n)" ;;
        esac
    done
}

function cp_backup() {
    typeset file=$1
    typeset new_location=$2
    # check if duplicate file
    if [[ $(find $new_location -maxdepth 1 \
        -iname $(basename $file) 2>/dev/null) ]]; then
        # do not write over oldest version
        typeset past_version=$new_location$(basename $file)"_"$(date_tag)
        if [[ $(find $new_location -maxdepth 1 \
            -iname $(basename $past_version) 2>/dev/null) ]]; then
            # add hr, min, sec stamp if necessary
            typeset path=${new_location}/$(basename $file)
            mv $path $past_version-$(date +"%H%M%S")
            echo $past_version-$(date +"%H%M%S")
        else
            # make a backup of the old version
            typeset path=${new_location}/$(basename $file)
            mv $path $past_version
            echo $past_version
        fi
    fi
    # copy file to desired location
    cp -r $file $new_location
}

function date_tag() {
    typeset DAY=$(date -d "$D" '+%d')
    typeset MONTH=$(date -d "$D" '+%m')
    typeset YEAR=$(date -d "$D" '+%y')
    echo $YEAR$MONTH$DAY
}

function tmux_kill() {
    list="$(tmux ls | awk '{print $1}' | sed 's/://g')"
    re='^[0-9]+$'

    for i in $list; do
        if [[ $i =~ $re ]]; then
            tmux kill-session -t $i
        fi
    done
}

function del() {
    trash_tag=$(date "+%y-%m-%d-%H-%M-%S")
    for file in "$@"; do
        mv "$file" ~/.trash/$trash_tag-$file
    done
}

function rt() {
    top_level=$(git rev-parse --show-toplevel 2>/dev/null)
    echo "$(basename $top_level)"
    if [[ $top_level != "" ]]; then
        cd $top_level
    fi
}

main "$@"
