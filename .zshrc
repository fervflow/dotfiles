# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source /usr/share/cachyos-zsh-config/cachyos-config.zsh

## Oh My Zsh Plugins
plugins=(
    #git
    gitignore
    colorize
    colored-man-pages
    command-not-found
    cp
    zoxide
    #nvm
    #zsh-autosuggestions
    #F-Sy-H
    #zsh-autocomplete
)

# Override cd with zoxide
export ZOXIDE_CMD_OVERRIDE="cd"

source $ZSH/oh-my-zsh.sh

## ALIASES
source $HOME/.zsh_aliases

## EXPORTS
export EDITOR="/usr/bin/nvim"
export ANDROID_HOME=~/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools
export PATH="$PATH":"$HOME/.pub-cache/bin"

# Delete word backwards when pressing leftctrl+back
bindkey '^H' backward-kill-word

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source /usr/share/nvm/init-nvm.sh

## [Completion]
## Completion scripts setup. Remove the following line to uninstall
[[ -f /home/ferv/.dart-cli-completion/zsh-config.zsh ]] && . /home/ferv/.dart-cli-completion/zsh-config.zsh || true
## [/Completion]

