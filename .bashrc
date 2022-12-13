# ~/.bashrc: executed by bash(1) for interactive shells.

# If not running interactively, don't do anything
[[ "$-" == *i* ]] || return

# Warning: this file is a pretty big mess. If you want all my latest stuff in
# a more sane format, look at my .zshrc (and respective files in .zshrc.d)

dosource() {
    [[ -f $1 ]] && source "$1"
}

dosource /usr/share/fzf/key-bindings.bash
dosource /usr/share/doc/pkgfile/command-not-found.bash
dosource /usr/local/scripts/apps/gvim.sh

export PROMPT_COMMAND=__prompt_command  # Func to gen PS1 after CMDs

__prompt_command() {
    local RESET='\[\e[0m\]'
    local RED='\[\e[0;31m\]'
    local GREEN='\[\e[0;32m\]'
    local YELLOW='\[\e[0;33m\]'

    if [[ $? -eq 0 ]]; then
        PS1=""
    else
        PS1="${RED}${RET}${RESET} "
    fi

    PS1+="${GREEN}\u@\h${RESET} ${YELLOW}\w${RESET}"

    if [[ $EUID -eq 0 ]]; then
        PS1+="${RED}#${RESET} "
    else
        PS1+="\$ "
    fi
}

PS2='... '

### ENVIRONMENT ###
export EDITOR=vim
export VISUAL="$EDITOR"
export GPGKEY=2C3CF0C7
export LD_LIBRARY_PATH='/usr/local/lib'

### FUNCTIONS ###

# For math commands, e.g. = 2+5*3
=() {
    if [[ $1 == -h ]] || [[ $1 == --help ]]; then
        man bc
        return
    fi

    local calc="${@//x/*}"
    calc="${calc//,/}"
    calc="${calc//\[/\(}"
    calc="${calc//\]/\)}"
    bc -l <<< "scale=10;$calc"
}

# For comparing binary files
bdiff() {
    if [[ $# -lt 2 ]]; then
        echo "Not enough arguments."
        echo "Usage: bdiff first-file second-file"
        return 1
    fi

    cmp -l "$1" "$2" | gawk '{printf "%08X %02X %02X\n", $1-1, strtonum(0$2), strtonum(0$3)}'
}

anon() {
    local name="anonymous"
    local host="gentoo"

    PS1=${PS1//\\u/"$name"} PS1=${PS1//\\h/"$host"}
    clear
}

# Extract audio from a video
exaudio() {
    if [[ "$#" -lt 2 ]]; then
        echo 'Usage: exaudio "webm-file" "output-file-with-extension"'
        return 1
    fi

    ffmpeg -i "$1" -vn -acodec copy "$2"
}

# Simple function to calculate date differences
datediff() {
    d1=$(date -d "$1" +%s)
    d2=$(date -d "$2" +%s)
    echo $(( (d1 - d2) / 86400 )) days
}

# Changes up how the train looks
sl() {
    local sett=e
    local rand=$[ RANDOM % 8 ]

    [ $[ $rand & 1 ] -gt 0 ] && sett+=a
    [ $[ $rand & 2 ] -gt 0 ] && sett+=l
    [ $[ $rand & 4 ] -gt 0 ] && sett+=F
    [ $[ $rand & 8 ] -gt 0 ] && sett+=c

    env sl -$sett
}

confirm() {
    read -p "Are you sure? [y/N] " confirm
    case "$confirm" in
        yes) return 0 ;;
        y) return 0 ;;
        Y) return 0 ;;
        *) return 1 ;;
    esac
}

findapp() {
    while [[ $# -gt 0 ]]; do
        grep -rnw "$1" /usr/share/applications/
        grep -rnw "$1" ~/.local/share/applications/
        shift
    done
}

totalcol() {
    if [ x$1 = x ]; then set `echo 1`; fi
    awk "{total += \$$1} END {print total}"
}

whitenoise() {
    play -n synth 60:00 brownnoise -65 tremolo .20 vol -20db
}

pjson() {
    echo "$@" | python -m json.tool
}

# Count the number of files in the directory.
countf() {
    if [[ $# -eq 0 ]]; then
        ls -1 | wc -l
    else
        ls -1 $@ | wc -l
    fi
}

# List the options supported by this terminal.
termsupport() {
    infocmp -1 | \
      sed -nu 's/^[ \000\t]*//;s/[ \000\t]*$//;/[^ \t\000]\{1,\}/!d;/acsc/d;s/=.*,//p' | \
      column -c80
}

### ALIASES ###
alias allgrp='cut -d: -f1 /etc/group'
alias allusr='cut -d: -f1 /etc/passwd'
alias diff='colordiff'
alias trash='trash-put'
alias srcrc='. ~/.bashrc'
alias vii3='vi ~/.config/i3/config'
alias virc='vi -p ~/.zshrc ~/.zshrc.d/*'
alias vibrc='vi ~/.bashrc'
alias wkclear='/usr/bin/clear'
alias clear='printf "\033c"'
alias shred='shred -uv'
alias which='which -a'
alias mocp='mocp -T black_theme'
alias randomart='ssh-keygen -lv -f'
alias checkip='curl ifconfig.me'
alias largest="find . -printf '%s %p\n' | sort -nr | head"
alias smallest="find . -printf '%s %p\n' | sort -nr | tail"
alias week='date +"%V"'
alias chanstamp='date +%s%3N'
alias mkdesktop='/usr/local/scripts/mkdesktop.sh'
alias maze='Z=╱╲;for((;;)){ printf ${Z:RANDOM&1:1};sleep .01;};unset Z'
alias myjpg='jpegoptim --force --all-progressive --strip-all --strip-com --strip-exif --strip-iptc --strip-icc --strip-xmp --totals'
alias mypng='optipng -strip all -i 0'
alias ytmp3='youtube-dl -o %\(title\)s.%\(ext\)s --extract-audio'
alias tty-clock='/usr/local/scripts/wm/tty-clock.sh'
alias mpvnc='mpv --speed=1.5 --audio-pitch-correction=no --no-video'
alias mpvac='mpv --speed=0.67 --audio-pitch-correction=no --no-video'

# Default to human readable figures
alias df='df -h'
alias du='du -h'

# Safety measures:
# * Verbosity so you know what's going on
# * Prevent rm from removing file systems
# * Prevent chmod from operating on /
alias mv='mv -v'
alias rm='rm -v --one-file-system'
alias cp='cp -v'
alias ln='ln -v'
alias chmod='chmod -v --preserve-root'

# Colorize output of some programs
alias grep='grep --color'                     # show differences in colour
alias egrep='egrep --color=auto'              # show differences in colour
alias fgrep='fgrep --color=auto'              # show differences in colour
alias ls='ls -hHF --color=tty'                # classify files in colour
alias ll='ls -l'                              # long list
alias la='ls -A'                              # all but . and ..
alias less='less -r'                          # raw control characters

cdls() { cd "$@" && ls; }
mkcd() { mkdir -p "$@" && cd "$@"; }
strerror() { python -c "import os; print os.strerror($1)"; }
roll() { local l=$1; [ -z "$l" ] && l=100; echo $[ 1 + $[ RANDOM % ${l} ]]; }
pls() { sudo -- "${SHELL:-bash}" -c "$(fc -ln -1)"; }
pexec() { echo $@; $@; }
mostused() { history | awk 'BEGIN {FS="[ \t]+|\\|"} {print $3}' | sort | uniq -c | sort -nr | head; }

red()   { echo -e "\e[31m\e[1m"$@"\e[0m"; }
green() { echo -e "\e[32m\e[1m"$@"\e[0m"; }
blue()  { echo -e "\e[34m\e[1m"$@"\e[0m"; }

# Umask
#
# /etc/profile sets 022, removing write perms to group + others.
# Set a more restrictive umask: i.e. no exec perms for others:
# umask 027
# Paranoid: neither group nor others have any perms:
# umask 077

# Functions
#
# Some people use a different file for functions
# if [ -f "${HOME}/.bash_functions" ]; then
#   source "${HOME}/.bash_functions"
# fi

settitle() {
   echo -ne "\e]2;$@\a\e]1;$@\a"; 
}

# This function defines a 'cd' replacement function capable of keeping, 
# displaying and accessing history of visited directories, up to 10 entries.
# Type "cd --" to get a list of past locations.
# acd_func 1.0.5, 10-nov-2004
# Petar Marinov, http:/geocities.com/h2428, this is public domain
cd() {
  local x2 the_new_dir adir index
  local -i count

  if [[ $1 ==  "--" ]]; then
    dirs -v
    return 0
  fi

  the_new_dir=$1
  [[ -z $1 ]] && the_new_dir=$HOME

  if [[ ${the_new_dir:0:1} == '-' ]]; then
    #
    # Extract dir N from dirs
    index=${the_new_dir:1}
    [[ -z $index ]] && index=1
    adir=$(dirs +$index)
    [[ -z $adir ]] && return 1
    the_new_dir=$adir
  fi

  # '~' has to be substituted by ${HOME}
  [[ ${the_new_dir:0:1} == '~' ]] && the_new_dir="${HOME}${the_new_dir:1}"

  #
  # Now change to the new dir and add to the top of the stack
  pushd "${the_new_dir}" > /dev/null
  [[ $? -ne 0 ]] && return 1
  the_new_dir=$(pwd)

  #
  # Trim down everything beyond 11th entry
  popd -n +11 2>/dev/null 1>/dev/null

  #
  # Remove any other occurence of this dir, skipping the top of the stack
  for ((count=1; count <= 10; count++)); do
    x2=$(dirs +${count} 2>/dev/null)
    [[ $? -ne 0 ]] && return 0
    [[ ${x2:0:1} == '~' ]] && x2="${HOME}${x2:1}"
    if [[ "${x2}" == "${the_new_dir}" ]]; then
      popd -n +$count 2>/dev/null 1>/dev/null
      count=count-1
    fi
  done

  return 0
}
