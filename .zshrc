#!/bin/zsh
#
# Zsh rice configuration

# Source EXPORTS of paths and other env vars
[[ -f ~/.zsh_exports ]] && source ~/.zsh_exports

# Source zsh PLUGIN MANAGER and PLUGINS
[[ -f $HOME/.zsh_plugins ]] && source $HOME/.zsh_plugins

# Load prompt
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/ferv-theme.toml)"

# Source ZSH OPTIONS configuration
[[ -f $HOME/.zsh_options ]] && source $HOME/.zsh_options

# Source ALIASES
[[ -f $HOME/.zsh_aliases ]] && source $HOME/.zsh_aliases

# Source BINDKEYS
[[ -f $HOME/.zsh_bindkeys ]] && source $HOME/.zsh_bindkeys

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd=cd zsh)"

## [Completion]
## Completion scripts setup. Remove the following line to uninstall
[[ -f ~/.dart-cli-completion/zsh-config.zsh ]] && . ~/.dart-cli-completion/zsh-config.zsh || true
## [/Completion]


