# ~/.bashrc
[[ $- != *i* ]] && return

# Impresión de banner al abrir terminal
cat ~/.banner

#PS1='[\u@\h \W]\$ '
export PS1="[\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;10m\]\u\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;15m\]@\h \[$(tput sgr0)\]\[\033[38;5;11m\]\W\[$(tput sgr0)\]\[\033[38;5;15m\]]\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;10m\]\\$\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]"
eval $(dircolors ~/.dircolors)

# Aliases
alias home='cd ~'
alias ls='ls --color=auto'
alias ll='ls -l'
alias la='ls -la'
alias grep='grep --color=auto'
alias protonvpn1='sudo protonvpn-cli -f'
alias protonvpn0='sudo protonvpn-cli -d'
alias ifconfig='grc ifconfig'
alias ps='grc ps'
alias netstat='grc netstat'
alias tail='grc tail'
alias desmume='desmume --fwlang=5'