#
# ~/.bashrc
#
# If not running interactively, don't do anything
[[ $- != *i* ]] && return
PS1='[\u@\h \W]\$ '
 
alias home='cd ~'
# Listado de archivos
alias ls='ls --color=auto'
alias ll='ls -l'
alias la='ls -la'