# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' file-sort name
zstyle ':completion:*' ignore-parents parent pwd
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'l:|=* r:|=*'
zstyle ':completion:*' menu select=1
zstyle ':completion:*' original true
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle ':completion:*' select-prompt %SScrolling %p%s
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose false
zstyle :compinstall filename '/home/ammon/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory autocd extendedglob nomatch notify hist_ignore_space
unsetopt beep
bindkey -v
# End of lines configured by zsh-newuser-install

dosource() {
    [[ -f "$1" ]] && source "$1"
}

# Source oh-my-zsh setting
source "${HOME}/.zshrc.d/oh-my-zsh"

# LS_COLORS is part of oh-my-zsh, so set completion colors here
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Source files from .zshrc.d/
source "${HOME}/.zshrc.d/aliases"
source "${HOME}/.zshrc.d/aliases-systemd"
source "${HOME}/.zshrc.d/func"
source "${HOME}/.zshrc.d/env"
source "${HOME}/.zshrc.d/misc"

# Other sourcing
dosource '/usr/share/fzf/key-bindings.zsh'
dosource '/usr/local/share/fzf/key-bindings.zsh'
dosource '/usr/share/doc/pkgfile/command-not-found.zsh'
dosource '/etc/profile.d/fzf-extras.zsh'
dosource "${HOME}/.travis/travis.sh"
which thefuck > /dev/null && eval "$(thefuck --alias)"

