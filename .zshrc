# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' file-sort name
zstyle ':completion:*' ignore-parents parent pwd
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
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

# Plugins for oh-my-zsh
plugins=(chucknorris encode64 gem git github jsontools lol npm nyan pip scala urltools safe-paste)

# Source files from .zshrc.d/
source "${HOME}/.zshrc.d/aliases"
source "${HOME}/.zshrc.d/func"
source "${HOME}/.zshrc.d/env"
source "${HOME}/.zshrc.d/misc"
#source "${HOME}/.zshrc.d/oh-my-zsh"

# Other sourcing
source '/usr/share/fzf/key-bindings.zsh'
source '/usr/share/doc/pkgfile/command-not-found.zsh'
source '/etc/profile.d/fzf-extras.zsh'
#source '/usr/lib/python3.5/site-packages/powerline/bindings/zsh/powerline.zsh'
eval "$(thefuck --alias)"

