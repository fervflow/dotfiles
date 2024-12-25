# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#source /usr/share/cachyos-zsh-config/cachyos-config.zsh
[[ -e ~/.profile ]] && emulate sh -c 'source ~/.profile'

# Source Oh-My-Zsh configurations
[[ -f $HOME/.zsh_omz ]] && source $HOME/.zsh_omz

# Source aliases
[[ -f $HOME/.zsh_aliases ]] && source $HOME/.zsh_aliases

# Delete word backwards when pressing leftctrl+back
bindkey '^H' backward-kill-word

# Load zsh plugins
# Fish-like syntax highlighting and autosuggestions
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# Use history substring search
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
# pkgfile "command not found" handler
source /usr/share/doc/pkgfile/command-not-found.zsh

# Load p10k zsh theme
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source /usr/share/nvm/init-nvm.sh

## [Completion]
## Completion scripts setup. Remove the following line to uninstall
[[ -f ~/.dart-cli-completion/zsh-config.zsh ]] && . ~/.dart-cli-completion/zsh-config.zsh || true
## [/Completion]

