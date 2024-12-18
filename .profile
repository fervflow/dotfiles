# EXPORTS

# User configuration
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Ignore commands that start with spaces and duplicates.
export HISTCONTROL=ignoreboth
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Don't add certain commands to the history file.
export HISTIGNORE="&:[bf]g:c:clear:history:exit:q:pwd:* --help"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Use custom `less` colors for `man` pages.
export LESS_TERMCAP_md="$(tput bold 2> /dev/null; tput setaf 2 2> /dev/null)"
export LESS_TERMCAP_me="$(tput sgr0 2> /dev/null)"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Make new shells get the history lines from all previous
# shells instead of the default "last window closed" history.
export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Default apps
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Neovim as the default editor
export EDITOR="/usr/bin/nvim"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# PATHs
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Android development paths, from Android Studio's docs
export ANDROID_HOME=~/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools
export PATH="$PATH":"$HOME/.pub-cache/bin"
# Added by Toolbox App
export PATH="$PATH:$HOME/.local/share/JetBrains/Toolbox/scripts"
# fzf path
export FZF_BASE=/usr/share/fzf
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# MODULES
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# gtk module for app menu for compatibility with gtk apps
export GTK_MODULES="appmenu-gtk-module"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

