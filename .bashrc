export PATH="/usr/local/bin:$PATH"

export DEV_DIR="$HOME/VimDev"

PS1='\w '

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
alias localSync="$DEV_DIR/neovim/localSync.sh"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export FLEET_TRACKER_CONFIG_FILE_PATH="~/config-cpc/fleet-tracker-service/fleet-tracker.config.yaml"
export CONFIGURATION_READING_CONFIG_FILE_PATH="~/config-cpc/company-config-reading/company-config-reading.yaml"
export MONITORING_CONFIG_FILE_PATH="~/config-cpc/customer-monitoring-service/customer-monitoring-service.config.yaml"
export ERP_QUERY_CONFIG_FILE_PATH="~/config-cpc/erp-query-service/erp-query-service.config.yaml"
export FLEET_LOADER_CONFIG_FILE_PATH="~/config-cpc/fleet-loader-service/fleet-loader-service.config.yaml"
export ERP2_CONFIG_FILE_PATH="~/config-cpc/erp2-service/erp2-service.config.yaml"
