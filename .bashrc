export PATH="/usr/local/bin:$PATH"
export USER=$(whoami)

PS1='\w '

export DEV_DIR="/root/.ovim"

alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gd='git diff'
alias gp='git push'
alias ll='ls -lah'
alias vim='nvim'
alias v='nvim'
alias c='clear'
alias ta='tmux a -t'
alias t='tmux'
alias localSync="/root/.ovim/neovim/localSync.sh"
alias 'docker-compose'="/root/.config/customCompose.sh"

docker() {
    if [[ "$1" == "compose" ]]; then
        shift
        /root/.config/customCompose.sh "$@"
    else
        command docker "$@"
    fi
}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

source /root/.env

shopt -s histappend
PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
export HISTCONTROL=ignoredups:erasedups

# Only run in interactive shell
if [[ $- == *i* ]] && [[ -z "$IN_VIM_TERMINAL" ]]; then
  export IN_VIM_TERMINAL=1
  vim -c 'terminal' -c 'startinsert'
  exit
fi
