# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Source EXPORTS of paths and other env vars
[[ -f ~/.zsh_exports ]] && source ~/.zsh_exports

# Source zsh PLUGIN MANAGER and PLUGINS
[[ -f $HOME/.zsh_plugins ]] && source $HOME/.zsh_plugins

# Load completions
#autoload -Uz compinit && compinit
#zinit cdreplay -q

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

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


