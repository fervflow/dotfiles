#!/usr/bin/env bash

set -euo pipefail

ALACRITTY_DIR="$HOME/.config/alacritty"
THEMES_DIR="$ALACRITTY_DIR/themes/themes"
ACTIVE_THEME="$ALACRITTY_DIR/active-theme.toml"
ALACRITTY_CONFIG="$ALACRITTY_DIR/alacritty.toml"

DARK_THEME="$THEMES_DIR/tokyo_night_storm.toml"
LIGHT_THEME="$THEMES_DIR/ashes_light.toml"

get_color_scheme() {
    local result

    result="$(
        gdbus call \
            --session \
            --dest org.freedesktop.portal.Desktop \
            --object-path /org/freedesktop/portal/desktop \
            --method org.freedesktop.portal.Settings.ReadOne \
            org.freedesktop.appearance \
            color-scheme \
            2>/dev/null || true
    )

    # XDG Desktop Portal:
    # 0 = no preference
    # 1 = prefer dark
    # 2 = prefer light
    if [[ "$result" =~ uint32[[:space:]]([0-9]+) ]]; then
        printf '%s\n' "${BASH_REMATCH[1]}"
        return 0
    fi

    # KDE fallback when the portal is unavailable.
    local kde_scheme

    kde_scheme="$(
        kreadconfig6 \
            --file kdeglobals \
            --group General \
            --key ColorScheme \
            2>/dev/null || true
    )"

    case "$kde_scheme" in
        *Dark*|*dark*)
            printf '1\n'
            ;;
        *Light*|*light*)
            printf '2\n'
            ;;
        *)
            printf '1\n'
            ;;
    esac
}

scheme="$(get_color_scheme)"

case "$scheme" in
    1)
        selected="$DARK_THEME"
        ;;
    2)
        selected="$LIGHT_THEME"
        ;;
    *)
        selected="$DARK_THEME"
        ;;
esac

if [[ ! -f "$selected" ]]; then
    echo "ERROR: theme file not found:" >&2
    echo "  $selected" >&2
    exit 1
fi

mkdir -p "$ALACRITTY_DIR"

# Replace the generated link atomically.
ln -sfn "$selected" "$ACTIVE_THEME"

# Make running Alacritty instances reload the imported theme.
touch "$ALACRITTY_CONFIG"

printf 'Alacritty theme: %s\n' "$(basename "$selected")"

