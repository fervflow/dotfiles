#!/usr/bin/env bash

set -u

SYNC="$HOME/.local/bin/alacritty-theme-sync"

# Synchronize once when the service starts.
"$SYNC"

# Watch only the XDG desktop portal's appearance settings.
gdbus monitor \
    --session \
    --dest org.freedesktop.portal.Desktop \
    --object-path /org/freedesktop/portal/desktop |
while IFS= read -r line; do
    # Example signal:
    #
    # SettingChanged (
    #     'org.freedesktop.appearance',
    #     'color-scheme',
    #     <uint32 1>
    # )

    if [[ "$line" == *"SettingChanged"* &&
          "$line" == *"org.freedesktop.appearance"* &&
          "$line" == *"color-scheme"* ]]; then
        "$SYNC"
    fi
done

