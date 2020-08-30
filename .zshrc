# compinstall (auto) {{{
########################

zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' file-sort name
zstyle ':completion:*' ignore-parents parent pwd
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or start typing%s
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'l:|=* r:|=*'
zstyle ':completion:*' menu select=1
zstyle ':completion:*' original true
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle ':completion:*' select-prompt %SScrolling %p%s
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose false
zstyle :compinstall filename "$HOME/.zshrc"

autoload -Uz compinit
compinit

#####
# }}}

# zsh-newuser-install (auto) {{{
################################

HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=100000
setopt appendhistory autocd extendedglob nomatch notify hist_ignore_space
unsetopt beep
bindkey -v

#####
# }}}

# oh-my-zsh {{{
###############

case "$(uname)" in
	Darwin)
		ZSH="$HOME/.oh-my-zsh"
		;;
	Linux)
		ZSH="/usr/share/oh-my-zsh/"
		;;
esac

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="ammon"

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="false"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="yyyy-mm-dd"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
plugins=(jsontools pip safe-paste urltools vi-mode zsh-autosuggestions)

# User configuration
# You may need to manually set your language environment

ZSH_CACHE_DIR="$HOME/.cache/zsh"
ZSH_CUSTOM="$HOME/.oh-my-zsh"

# LS_COLORS is part of oh-my-zsh, so set completion colors here
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

source "$ZSH/oh-my-zsh.sh"

#####
# }}}

# pyenv {{{
###########

if which pyenv > /dev/null; then
	export PYENV_SHELL=zsh
	command pyenv rehash 2> /dev/null

	pyenv() {
		local command
		command="${1:-}"
		if [[ $# -gt 0 ]]; then
			shift
		fi

		case "$command" in
			rehash|shell)
				eval "$(pyenv "sh-$command" "$@")"
				;;
			*)
				command pyenv "$command" "$@"
				;;
		esac
	}

	# Use bpython when not invoking pyenv
	python()  { [[ $# -eq 0 ]] && bpython  || "$HOME/.pyenv/shims/python"  "$@"; }
	python2() { [[ $# -eq 0 ]] && bpython2 ||                 env python2  "$@"; }
	python3() { [[ $# -eq 0 ]] && bpython3 || "$HOME/.pyenv/shims/python3" "$@"; }
else
	# Use regular bpython
	python()  { bpython  "$@"; }
	python2() { bpython2 "$@"; }
	python3() { bpython3 "$@"; }
fi

#####
# }}}

# Default Aliases {{{
#####################

alias clear='printf "\033c"'
alias cower='cower --color auto'
alias df='df -kTh'
alias du='du -kh'
alias ed='ed -p: -v'
alias free='free -h'
alias grep='noglob rg'
alias iftop='sudo iftop'
alias iotop='sudo iotop -o'
alias nethogs='sudo nethogs'
alias nomino='noglob nomino -p'
alias pdflatex='pdflatex -halt-on-error'
alias pgrep='pgrep -afl'
alias rg='noglob rg'
alias shred='shred -uv'
alias socat='noglob socat'
alias sudo='sudo -EH'
alias view='vim -R'
alias vim='vim -p'
alias which='which -a'
alias xsnow='xsnow -nokeepsnow -notrees'

# Colorize output
alias diff='colordiff'
alias less='less -RMSi'

# Modifiers on file operations
alias cp='cp -v'
alias ln='ln -v'
alias mv='mv -v'
alias rmln='rmln -v'

# Others
i3-resurrect() {
	local command="$1"
	shift

	env \
		i3-resurrect "$command" \
			--directory "$HOME/.config/i3/i3-resurrect" \
			"$@"
}

#####
# }}}

# Platform-specific aliases {{{
###############################

case "$(uname)" in
	Darwin)
		alias chmod='chmod -v'
		alias df='df -kh'
		alias grep='grep -I --color=auto'
		alias ls='ls -GFL'
		alias rm='rm -v'
		alias stat='gstat'
		alias vim='env vim -p'
		alias ldd='otool -L'
		;;
	Linux)
		alias chmod='chmod -c --preserve-root'
		alias ls='ls -hHFNv --color=tty'
		alias rm='rm -v --one-file-system'
		alias grep='grep -I --color'
		alias egrep='egrep --color=auto'
		alias fgrep='fgrep --color=auto'
		alias open='xdg-open'
		alias pbcopy='xsel -bi'
		alias pbpaste='xclip -o'
		alias pbclear='xsel -c'
		alias rmdir='rmdir -v'
		alias livestreamer='streamlink'
		;;
esac

if which gls > /dev/null; then
	alias ls='gls -hHFN --group-directories-first --color=tty'
fi

#####
# }}}

# Custom aliases {{{
####################

# Derivative
alias cpa='cp -a'

# 'ls' commands
if which exa > /dev/null; then
	alias ls='exa'
	alias la='exa -a'
	alias laa='exa -aa'
	alias latr='exa -al --sort=newest'
	alias lc='exa -lr --sort=created'
	alias lk='exa -l --sort=size'
	alias ll='exa -l --git'
	alias lla='exa -la --git'
	alias llaa='exa -laa --git'
	alias lm='exa -l | less'
	alias ltr='exa -l --sort=newest'
	alias lu='exa -l --sort=accessed'
	alias lxb='exa -l --sort=extension'
else
	alias la='ls -A'
	alias laa='ls -a'
	alias latr='ls -Altr'
	alias lc='ls -ltcr'      # Sort by change time, most recent last
	alias lk='ls -lSr'       # Sort by size, biggest last
	alias ll='ls -l'
	alias lla='ls -Al'
	alias llaa='ls -al'
	alias lm='ll | less'
	alias ltr='ls -ltr'      # Sort by date, most recent last
	alias lu='ls -ltur'      # Sort by access time, most recent last
	alias lxb='ls -lXB'      # Sort by extension
fi

# Custom operations
alias allgrp='cut -d: -f1 /etc/group'
alias allusr='cut -d: -f1 /etc/passwd'
alias ctime='date +"%A %B %d, %Y %I:%M:%S %p"'
alias define='sdcv'
alias doc2pdf='libreoffice --headless --invisible --norestore --convert-to pdf'
alias dtail='dmesg | tail'
alias keyart='ssh-keygen -lv -f'
alias lsnet='env ls /sys/class/net'
alias nonetwork='LD_PRELOAD=/usr/local/lib/nonetwork.so'
alias srcrc='source ~/.zshrc'
alias tty-clock='/usr/local/scripts/wm/tty-clock.sh'
alias vii3='vim ~/.config/i3/config'
alias virc='vim ~/.zshrc'
alias vibrc='vim ~/.bashrc'
alias vimrc='vim ~/.vimrc'
alias week='date +%V'
alias ytalb='noglob youtube-dl -x --prefer-free-formats -o "%(autonumber)s - %(title)s.%(ext)s" --autonumber-size 2'
alias ytdl='noglob youtube-dl -i -o "%(title)s.%(ext)s"'
alias ytmp3='noglob youtube-dl -x -o "%(title)s.%(ext)s"'
alias md='mkdir -p'

# Program modifiers
alias jp='LC_ALL=ja_JP.UTF-8'

# SSH shortcuts
alias adam='ssh Adam'
alias titus='ssh Titus'

# Valgrind shortcuts
alias memcheck='valgrind --tool=memcheck'
alias cachegrind='valgrind --tool=cachegrind'
alias callgrind='valgrind --tool=callgrind'
alias helgrind='valgrind --tool=helgrind'
alias drd='valgrind --tool=drd'
alias massif='valgrind --tool=massif'
alias dhat='valgrind --tool=dhat'
alias sgcheck='valgrind --tool=sgcheck'
alias bbv='valgrind --tool=bbv'
alias lackey='valgrind --tool=lackey'
alias nulgrind='valgrind --tool=none'

# File navigation commands
alias largest="find . -printf '%s %p\n' | sort -nr | head"
alias smallest="find . -printf '%s %p\n' | sort -nr | tail"

# For fun
alias chanstamp='date +%s%3N'
alias maze='_maze=╱╲;for((;;)){ printf ${_maze:RANDOM&1:1};sleep .01;};unset _maze'
alias mpvnc='mpv --speed=1.5 --audio-pitch-correction=no --no-video'
alias mpvac='mpv --speed=0.67 --audio-pitch-correction=no --no-video'

#####
# }}}

# Short Functions {{{
#####################

# Shortcut commands
catls() {
	[[ -d "$1" ]] \
		&& ls "$1" \
		|| cat "$1"
}

cdls() {
	cd "$@" && ls
}

cdmv() {
	mv "$1" "$2" && cd "$2"
}

countf() {
	/usr/bin/ls -1 "$@" | wc -l
}

define2() {
	curl "dict://dict.org/d:$1"
}

digq() {
	dig "$@" | grep 'Query time'
}

home() {
	cd "$HOME" && clear
}

lsicon() {
	ls -1 /usr/share/icons/Numix-Circle/scalable/apps | grep "$1"
}

mkcd() {
	mkdir -p "$@" && cd "$@"
}

mvcd() {
	mv "$@" && cd "${@: -1}"
}

myip() {
	myip4
	myip6
}

myip4() {
	wget -qO- http://ipecho.net/plain
	echo
}

myip6() {
	wget -qO- http://ip6echo.net/plain/ \
		| sed -Ee 's/<[^>]+>|[[:space:]]+|What'\''s My IPv6 Address\?//g' -e '/^$/d'
}

pacbin() {
	pacman -Ql "$1" | /usr/bin/grep --color=never /bin/ | awk '{print $2}'
}

pexec() {
	echo "$@"
	"$@"
}

pls() {
	sudo -- "${SHELL:-zsh}" -c "$(fc -ln -1)"
}

realwhich() {
	realpath "$(env which "$1")"
}

shreddit() {
	env shreddit -c "$HOME/.config/shreddit/$1.yml" -u "$1"
}

termbin() {
	nc termbin.com 9999
}

trash() {
	[[ $# -eq 0 ]] \
		&& trash-list \
		|| trash-put "$@"
}


# Colorize text
red()    { printf "\e[31m\e[1m%s\e[0m" "$@"; }
green()  { printf "\e[32m\e[1m%s\e[0m" "$@"; }
blue()   { printf "\e[34m\e[1m%s\e[0m" "$@"; }
redl()   { printf "\e[31m%s\e[0m" "$@"; }
greenl() { printf "\e[32m%s\e[0m" "$@"; }
bluel()  { printf "\e[34m%s\e[0m" "$@"; }

# Hash checkers
md5check()    { [[ $(md5sum    "$2" | cut -d' ' -f1) == "$1" ]] && green '[OK]' || red '[FAIL]'; }
sha1check()   { [[ $(sha1sum   "$2" | cut -d' ' -f1) == "$1" ]] && green '[OK]' || red '[FAIL]'; }
sha224check() { [[ $(sha224sum "$2" | cut -d' ' -f1) == "$1" ]] && green '[OK]' || red '[FAIL]'; }
sha256check() { [[ $(sha256sum "$2" | cut -d' ' -f1) == "$1" ]] && green '[OK]' || red '[FAIL]'; }
sha384check() { [[ $(sha384sum "$2" | cut -d' ' -f1) == "$1" ]] && green '[OK]' || red '[FAIL]'; }
sha512check() { [[ $(sha512sum "$2" | cut -d' ' -f1) == "$1" ]] && green '[OK]' || red '[FAIL]'; }

# Misc
note() { scr note "$@" 2> /dev/null; }
mpva() { @ mpv --no-audio-display "$@"; }
mpvq() { @ mpv --no-terminal "$@" & }
ytdlq() { ytdl "$@" >/dev/null 2>&1 & }

#####
# }}}

# Functions {{{
###############

# For screenfetches on anonymous imageboards
anon() {
	local name="anonymous"
	local host="gentoo"

	PS1=${PS1//\%n/"$name"} PS1=${PS1//\%M/"$host"}
	printf '\033c'
}

# Manually download PKGBUILD for building
aur() {
	if [[ $# -eq 0 ]]; then
		echo >&2 'No packages specified.'
		return 1
	fi

	(
	cd "$AURDEST"
	for pkg in "$@"; do
		git clone "https://aur.archlinux.org/$pkg.git"
	done
	)
}

# For comparing binary files
bdiff() {
	if [[ $# -lt 2 ]]; then
		echo >&2 'Not enough arguments.'
		echo >&2 'Usage: bdiff first-file second-file'
		return 1
	fi

	cmp -l "$1" "$2" | gawk '{printf "%08X %02X %02X\n", $1-1, strtonum(0$2), strtonum(0$3)}'
}

# Currency conversion. Be sure to use official abbreviations
cconv() {
	wget -qO- "http://www.google.com/finance/converter?a=$1&from=$2&to=$3" | sed '/res/!d;s/<[^>]*>//g';
}

# Run a command in a subshell with a different cwd
cddo() {
	if [[ $# -lt 2 ]]; then
		echo >&2 'Not enough arguments.'
		echo >&2 'Usage: cddo directory program [arguments...]'
		return 1
	fi

	(
	cd "$1"
	shift
	"$@"
	)
}

# A command replacement that says 'this command is disabled'.
command-disabled() {
	echo >&2 'This command has been disabled for safety purposes.'
	echo >&2 'If you really want to run it, invoke it directly. (e.g. /bin/false instead of false)'
	return 1
}

# A simple confirmation message. Usage: 'confirm && (action)'
confirm() {
	printf 'Are you sure? [y/N] '
	read -r confirm
	case "$confirm" in
		yes) return 0 ;;
		y) return 0 ;;
		Y) return 0 ;;
		*) return 1 ;;
	esac
}

# Detach from TTY
daemon() {
	"$@" \
		< /dev/null \
		> /dev/null \
		2> /dev/null \
		&
	disown
}

# Simple function to calculate date differences
datediff() {
	d1="$(date -d "$1" +%s)"
	d2="$(date -d "$2" +%s)"
	echo "$(( (d1 - d2) / 86400 ))" days
}

# Easily convert from base64
decode64() {
	if [[ $# -eq 0 ]]; then
		base64 --decode
	else
		base64 --decode <<< "$1"
	fi
}

# Easily convert to base64
encode64() {
	if [[ $# -eq 0 ]]; then
		base64
	else
		base64 <<< "$1"
	fi
}

# Disable fancy zsh completion on slow filesystems (e.g. NFS)
ftab() {
	zstyle ':completion:*' path-completion false
	zstyle ':completion:*' accept-exact-dirs true
	echo 'Disabled fancy tab completion'
}

# Batch converts from one format to another
ffbatch() {
	if [[ $# -lt 2 ]]; then
		echo >&2 'Not enough arguments.'
		echo >&2 'Usage: ffbatch mp3 ogg'
	fi

	find -type f -name "*.$1" -print0 \
		| while read -d $'\0' a; do
			ffmpeg -i "$a" "${a[@]/%$1/$2}" < /dev/null
		done
	#rm -ir **/*.$1
}

# Joins L and R tracks into a single file.
ffstereo() {
	if [[ $# -lt 3 ]]; then
		echo >&2 'Not enough arguments.'
		echo >&2 'Usage: ffstereo left-track-file right-track-file output-file'
		return 1
	fi

	ffmpeg -i "$1" -i "$2" -filter_complex "[0:a][1:a]amerge=inputs=2[aout]" -map "[aout]" -c:a flac "$3"
}

# Changes the volume of a video or audio file.
ffvolume() {
	if [[ $# -lt 3 ]]; then
		echo >&2 'Not enough arguments.'
		echo >&2 'Usage: ffvolume input-file output-file volume-modifier'
		return 1
	fi

	ffmpeg -i "$1" -af "volume=$3" "$2"
}

# Look for a certain .desktop file
findapp() {
	for arg in "$@"; do
		grep -rnw "$arg" "/usr/share/applications/"
		grep -rnw "$arg" "$HOME/.local/share/applications/"
	done
}

# Finds the volume of an audio file in decibels
getvolume() {
	ffmpeg -i "$1" -af 'volumedetect' -f null /dev/null
}

# Run gofmt on *.go files
gofmtall() {
	if [[ $# -eq 0 ]]; then
		gofmtall *.go
		return $?
	fi

	for fn in "$@"; do
		gofmt "$fn" | sponge "$fn"
	done
}

# Insult the user if their command fails.
insult() {
	# Warning: slow
	printf 'root says: '
	curl -s randominsults.net | sed -n '/<strong>/{s;^.*<i>\(.*\)</i>.*$;\1;p}'
}

# Make sure the user is kexec'ing the right machine
kexec() {
	sleep 0.5
	printf "About to reboot (via kexec) \e[1m%s\e[0m. You sure? " "$(cat /etc/hostname)"
	read -r response
	case "$response" in
		y*|Y*) sudo systemctl kexec ;;
		*) echo >&2 'Aborting.'
	esac
}

# List dbus services
lsdbus() {
	if [[ $# -eq 0 ]] || [[ $1 == '--help' ]]; then
		echo >&2 'Not enough arguments.'
		echo >&2 'Usage: lsdbus (session | system)'
		return 1
	fi

	dbus-send "--$1" \
			--dest=org.freedesktop.DBus \
			--type=method_call \
			--print-reply \
			/org/freedesktop \
			org.freedesktop.DBus.ListNames
}

# List file descriptors of the given pids or processes
lsfd() {
	if [[ $# -eq 0 ]]; then
		echo >&2 'Usage: lsfd (pid | process)...'
		return 1
	fi

	for arg in "$@"; do
		if [[ $arg -gt 0 ]]; then
			ls -l "/proc/$arg/fd"
		else
			env pgrep "$arg" | \
				while read -r pid; do
					echo "$pid"
					ls -lv "/proc/$pid/fd"
				done
		fi
	done
}

# List osu! songs
lsosu() {
	readonly local osu_song_dir='/media/media/games/osu!/Songs'

	if [[ $# -eq 0 ]]; then
		ls "$osu_song_dir"
	else
		ls "$osu_song_dir" | grep -i "$1"
	fi
}

# Print your most used shell commands
mostused() {
	history \
	  | awk '{ print $4 }' \
	  | sort \
	  | uniq -c \
	  | sort -nr \
	  | head -n 20
}

# Rename files with the same name to something else.
# Usage: movc original destination [extensions]
movc() {
	case "$#" in
		2)
			readonly local exts='ch'
			;;
		3)
			readonly local exts="$3"
			;;
		*)
			printf >&2 'Usage: movc ORIG DEST [EXTENSIONS]\n'
			return 1
			;;
	esac

	sed -e 's/\(.\)/\1\n/g' <<< "$exts" \
		| while read -r ext; do
			if [[ -z "$ext" ]]; then
				break;
			fi

			mv -v "$1.$ext" "$2.$ext" || true
		done
}

# (WORK) rename a JS file to TS and commit the change
mvts() {
	local stem="${1%.*}"

	git mv "$stem.js" "$stem.ts"
	git commit -m "Rename $stem.ts"
}

# Create a new shell without ssh-agent
nossh() {
	unset SSH_AGENT_PID
	unset SSH_AUTH_SOCK
}

# Run the given process without ssh-agent
nossh2() {
	(
	nossh
	exec ssh "$@"
	)
}

# Opens a caption stored in a directory
opencaption() {
	if [[ $# -eq 0 ]]; then
		echo >&2 'Usage: opencaption directory'
		return 1
	fi

	images=("$1"/*.{gif,jpg,jpeg,png}(N))
	if [[ ${#images} -gt 0 ]]; then
		nomacs -p "${images[1]}" >/dev/null 2>&1 &
	fi
	cat "$1/caption.txt"
}

# Print the 256 terminal colors (if supported)
p256() {
	local x="$(tput op)"
	local y="$(printf %$((${COLUMNS}-6))s)"
	for i in {0..256}; do
		local o="00$i"
		echo -e "${o:${#o}-3:3} "$(tput setaf $i; tput setab $i)"${y// /=}$x"
	done
}

# Reopen a PDF if the viewer closes
pdf-always() {
	if [[ $# -eq 0 ]]; then
		echo >&2 'Usage: pdf-always filename'
		return 1
	fi

	while true; do
		if [[ -f $1 ]]; then
			mupdf "$1"
		else
			sleep 1
		fi
	done
}

# Print number of processes
procno() {
	find /proc -maxdepth 1 -regex '/proc/[0-9]+' -printf . | wc -c
}

# Pretty print a JSON file
pjson() {
	python -m json.tool <<< "$@"
}

# Make sure the user is rebooting the right machine
reboot() {
	sleep 0.5
	printf "About to reboot \e[1m%s\e[0m. You sure? " "$(cat /etc/hostname)"
	read -r response
	case "$response" in
		y*|Y*) sudo reboot ;;
		*) echo >&2 'Aborting.'
	esac
}

# Run one of my scripts without specifying the path
scr() {
	if [[ $# -eq 0 ]]; then
		printf >&2 'Usage: scr script-name.\n'
		return 1
	fi

	IFS=$'\n' \
	local scripts=($(find -L '/usr/local/scripts' -iname "*$1*" -executable -print))
	case "${#scripts[@]}" in
		0)
			printf >&2 'Cannot find script "%s".\n' "$1"
			return 1
			;;
		1)
			local script="${scripts[1]}"
			echo "$script"
			shift
			"$script" "$@"
			return 0
			;;
		*)
			printf >&2 'Multiple script candidates:\n'
			printf >&2 '%s\n' "${scripts[@]}"
			return 1
			;;
	esac
}

# Default options for securefs mount
secmount() {
	if [[ $# -eq 0 ]]; then
		echo >&2 "Usage: secmount crypt-dir mount-dir [extra-flags]."
		return 1
	fi

	if [[ $# -ge 2 ]]; then
		local crypt_dir="$1"
		local mount_dir="$2"
		shift 2
	else
		local crypt_dir="$1.secfs"
		local mount_dir="$1"
		shift 1
	fi

	if [[ -f "$crypt_dir/.securefs.lock" ]]; then
		if pgrep securefs > /dev/null; then
			echo >&2 "securefs mount already running. if you're sure this isn't true, then remove $crypt_dir/.securefs.lock"
			return 1
		else
			rm "$crypt_dir/.securefs.lock"
		fi
	fi

	securefs mount -b --log "$crypt_dir/.securefs.log" "$@" -- "$crypt_dir" "$mount_dir"
}

# Set the title of the terminal
settitle() {
	echo -ne "\e]2;$@\a\e]1;$@\a"
}

# Changes up how the sl train looks
sl() {
	local sett=e
	readonly local rand="$RANDOM"

	[[ $[ $rand & 1 ] -gt 0 ]] && sett+=a
	[[ $[ $rand & 2 ] -gt 0 ]] && sett+=l
	[[ $[ $rand & 4 ] -gt 0 ]] && sett+=F
	[[ $[ $rand & 8 ] -gt 0 ]] && sett+=c

	env sl "-$sett"
}

# Make sure the user is shutting down the right machine
shutdown() {
	sleep 0.5
	printf "About to shutdown \e[1m%s\e[0m. You sure? " "$(cat /etc/hostname)"
	read -r response
	case "$response" in
		y*|Y*) sudo shutdown now ;;
		*) echo >&2 'Aborting.'
	esac
}

# Move all files into a directory to the current directory,
# then delete the directory
splat() {
	if [[ $# -eq 0 ]]; then
		echo "Usage: splat dir..."
		return 1
	fi

	for dir in "$@"; do
		if [[ ! -d $dir ]]; then
			echo "$dir is not a directory, skipping..."
			continue
		fi

		mv "$dir"/* .
		mv "$dir"/.* .
		rmdir "$dir"
	done
}

# Make sure the user is rebooting the right machine
reboot() {
	sleep 0.5
	printf "About to reboot \e[1m%s\e[0m. You sure? " "$(cat /etc/hostname)"
	read -r response
	case "$response" in
		y*|Y*) sudo reboot ;;
		*) echo >&2 'Aborting.'
	esac
}

# Get lengths of command line arguments
strlen() {
	for str in "$@"; do
		echo "${#str}"
	done
}

# Ask for confirmation and then suspend
suspend() {
	confirm && \
	suspendnow
}

# Suspend the computer
suspendnow() {
	systemctl suspend
}

# Suspend and lock the screen
suspendlock() {
	confirm && {
		suspendnow
		scr i3_lock.sh
	}
}

# Suspend and lock the tty
suspendvlock() {
	confirm && {
		suspendnow
		vlock
	}
}

# Use taffy to automatically tag a song
taffyit() {
	if [[ $1 == '-n' ]]; then
		add_artist=false
		shift
	else
		add_artist=true
	fi

	if [[ $# -eq 0 ]]; then
		echo >&2 'No files specified.'
		return 1
	fi

	if "$add_artist"; then
		local artist="${PWD##*/}"

		for fn in "$@"; do
			local title="${fn%.*}"
			echo "$fn: $title by $artist"
			taffy -r "$artist" -t "$title" "$fn"
		done
	else
		for fn in "$@"; do
			local title="${fn%.*}"
			echo "$fn: $title"
			taffy -t "$title" "$fn"
		done
	fi
}

# Use mid3v2 to automatically tag a song
tagit() {
	if [[ $1 == '-n' ]]; then
		add_artist=false
		shift
	else
		add_artist=true
	fi

	if [[ $# -eq 0 ]]; then
		echo >&2 'No files specified.'
		return 1
	fi

	if "$add_artist"; then
		local artist="${PWD##*/}"

		for fn in "$@"; do
			local title="${fn%.*}"
			echo "$fn: $title by $artist"
			mid3v2 -a "$artist" -t "$title" "$fn"
		done
	else
		for fn in "$@"; do
			local title="${fn%.*}"
			echo "$fn: $title"
			mid3v2 -t "$title" "$fn"
		done
	fi
}

# List the options supported by this terminal.
termsupport() {
	infocmp -1 | \
	  sed -nu 's/^[ \000\t]*//;s/[ \000\t]*$//;/[^ \t\000]\{1,\}/!d;/acsc/d;s/=.*,//p' | \
	  column -c80
}

# Make a total of all the integer items in a column
totalcol() {
	if [[ -z $1 ]]; then
		return 1
	fi

	awk "{total += \$$1} END {print total}"
}

# Copy files to transfer.sh
transfer() {
	if [[ $# -eq 0 ]]; then
		echo >&2 'No arguments specified.'
		echo >&2 'Usage: transfer [filename]'
		return 1
	elif ! confirm; then
		echo >&2 'Come back when you'\''re more sure.'
		return 1
	fi

	readonly local tmpfile="$(mktemp /tmp/transfershXXXXXX)"
	if tty -s; then
		readonly local basefile="$(basename "$1" | sed -e 's/[^a-zA-Z0-9._-]/-/g')"
		curl --progress-bar --upload-file "$1" "https://transfer.sh/$basefile" >> "$tmpfile"
	else
		curl --progress-bar --upload-file - "https://transfer.sh/$1" >> "$tmpfile"
	fi

	cat "$tmpfile"
	echo
	rm -f "$tmpfile" > /dev/null
}

# Get weather via wttr.in
weather() {
	if [[ $# -eq 0 ]]; then
		echo >&2 'Give a location. Ex: "ucr"'
		return 1
	fi

	case "$1" in
		nyc)
			readonly local location='NYC'
			;;
		ucr)
			readonly local location='Riverside'
			;;
		irvine)
			readonly local location='Irvine';
			;;
		*)
			printf >&2 'Unknown location: %s.\n', "$1"
			return 1
			;;
	esac
	curl -s "wttr.in/$location"
}

# Convert audio webms to opus without reencoding
webm2opus() {
	for fn in *.webm; do
		local dest="${fn:0:-4}opus"
		ffmpeg -i "$fn" -acodec copy "$dest"
	done
}

# Alias for wdiff
wdiff() {
	readonly local bold="$(tput bold)"
	readonly local sgr0="$(tput sgr0)"
	readonly local af1="$(tput setaf 1)"
	readonly local af2="$(tput setaf 2)"

	dwdiff \
		-w "${bold}${af1}" \
		-x "${sgr0}" \
		-y "${bold}${af2}" \
		-z "${sgr0}" \
		"$@"
}

# Play some random white noise
whitenoise() {
	play -n synth 60:00 brownnoise -65 tremolo .20 vol -20db
}

#####
# }}}

# systemd aliases {{{
#####################

# Shortcuts
alias jctl='journalctl'
alias sctl='systemctl'
alias scutl='systemctl --user'

# Commands
normal_commands=(
	'cat'
	'help'
	'is-active'
	'is-enabled'
	'list-jobs'
	'list-timers'
	'list-units'
	'list-unit-files'
	'show'
	'show-environment'
	'status'
)

perm_commands=(
	'cancel'
	'daemon-reexec'
	'daemon-reload'
	'disable'
	'edit'
	'enable'
	'isolate'
	'kill'
	'link'
	'load'
	'mask'
	'preset'
	'reenable'
	'reload'
	'reload-or-restart'
	'reset-failed'
	'restart'
	'set-environment'
	'start'
	'stop'
	'try-reload-or-restart'
	'try-restart'
	'unmask'
	'unset-environment'
)

for cmd in "${normal_commands[@]}"; do
	alias "sc-$cmd"="systemctl $cmd"
done

for cmd in ${perm_commands[@]}; do
	alias "sc-$cmd"="sudo systemctl $cmd"
done

for cmd in "${normal_commands[@]}" "${perm_commands[@]}"; do
	alias "scu-$cmd"="systemctl --user $cmd"
done

# Cleanup
unset cmd
unset normal_commands
unset sudo_commands

#####
# }}}

# Environment {{{
#################

# Variables
export LC_ALL='en_US.UTF-8'
export LANG="$LC_ALL"
export EDITOR='vim'
export VISUAL="$EDITOR"
export GPGKEY='2C3CF0C7'
export LD_LIBRARY_PATH="/usr/local/lib:$HOME/lib"
export AURDEST="/tmp/$USER/aur"
export GOPATH="$HOME/git/go"
export TESSDATA_PREFIX='/usr/share/tessdata'
export WINEPREFIX="$HOME/.wine"
export WINEHOME="$HOME/.wine"

# To prevent PATH from getting larger each time when re-sourcing
unset PATH
source /etc/profile

case "$(uname)" in
	Linux)
		if [[ $EUID != 0 ]]; then
			export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$(rustc --print sysroot)/lib"
		fi

		export PATH="$PATH:$HOME/.gem/ruby/2.3.0/bin:$HOME/.cabal/bin"

		# I dislike this ls alias
		unalias l
		;;
esac

export PATH="$HOME/bin:$HOME/.local/bin:$HOME/.npm/bin:$HOME/.cargo/bin:$HOME/.pyenv/shims:/var/lib/snapd/snap/bin:$PATH"

# Import systemd environment
if which systemctl > /dev/null; then
	systemctl --user show-environment \
		| while read -r var; do
			name="$(cut -d= -f1 <<< "$var")"
			if eval "[[ ! \${$name+x} ]]"; then
				eval "export $var"
			fi
		done
	unset name
fi

#####
# }}}

# Source files {{{
##################

dosource() {
	[[ -f "$1" ]] && source "$1"
}

dosource '/etc/profile.d/fzf-extras.zsh'
dosource '/usr/bin/aws_zsh_completer.sh'
dosource '/usr/lib/z.sh'
dosource '/usr/share/doc/pkgfile/command-not-found.zsh'
dosource '/usr/share/fzf/key-bindings.zsh'
dosource '/usr/share/nvm/init-nvm.sh'
dosource "$HOME/.travis/travis.sh"
dosource "$HOME/.zshrc_local"
which thefuck > /dev/null && eval "$(thefuck --alias)"

#####
# }}}

# Miscellaneous {{{
###################

# Set the home/end keys
bindkey "${terminfo[khome]}" beginning-of-line
bindkey "${terminfo[kend]}" end-of-line

which fzf > /dev/null || bindkey '^R' history-incremental-search-backward

if [[ "$EUID" -eq 0 ]]; then
	case "$(uname)" in
		Darwin)
			alias ls='ls -AGF'
			;;
		Linux)
			alias ls='ls -AhHF --color=tty'
			;;
	esac
fi

# Set up NVM
if [[ $(uname) == Darwin ]]; then
  export NVM_DIR="$HOME/.nvm"

  [[ -s "/usr/local/opt/nvm/nvm.sh" ]] && source "/usr/local/opt/nvm/nvm.sh"
  [[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ]] && source "/usr/local/opt/nvm/etc/bash_completion.d/nvm"
fi

# Allow GPG signing over SSH
export GPG_TTY="$(tty)"
[[ -n "$SSH_CONNECTION" ]] && export PINENTRY_USER_DATA='USE_CURSES=1'

# FIXME: hack to get rustc colors to work
cargo() { TERM=xterm env cargo "$@"; }

#####
# }}}

# vim: set noet fdm=marker foldlevel=0:
