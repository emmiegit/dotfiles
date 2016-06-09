ZSH_THEME_GIT_PROMPT_PREFIX=" (%F{blue}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%F{reset})"
ZSH_THEME_GIT_PROMPT_DIRTY="%F{red}!%F{reset}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

PS1='%F{green}%n@%M%f %F{yellow}%~%f%(!.%F{red}#%f.$)$(git_prompt_info) '
RPS1="%(?..%F{red}%? ↵%F{reset})"
PS2='%F{red}\ %F{reset}'

export LSCOLORS='Gxfxcxdxbxegedabagacad'
export LS_COLORS='di=1;34:ln=1;36:so=95:pi=33:ex=1;32:bd=1;35:cd=1;33:su=0;41:sg=0;46:tw=90;42:ow=90;43:mi=31'

# vim: set ft=zsh:
