#!/usr/bin/env bash

set -euo pipefail

# ============================================================
# PATHS
# ============================================================

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd -- "$SCRIPT_DIR/.." && pwd)"

ALACRITTY_DIR="$HOME/.config/alacritty"
THEMES_DIR="$ALACRITTY_DIR/themes"
THEMES_REPO="$THEMES_DIR"

USER_BIN="$HOME/.local/bin"
SYSTEMD_USER_DIR="$HOME/.config/systemd/user"

SCRIPTS_SOURCE="$DOTFILES_DIR/user-scripts/alacritty"
SERVICE_SOURCE="$DOTFILES_DIR/user-services/alacritty/alacritty-theme-sync.service"

THEME_REPO_URL="https://github.com/alacritty/alacritty-theme.git"


# ============================================================
# HELPERS
# ============================================================

info() {
    printf '\033[1;34m==>\033[0m %s\n' "$1"
}

success() {
    printf '\033[1;32m OK\033[0m %s\n' "$1"
}

error() {
    printf '\033[1;31mERROR\033[0m %s\n' "$1" >&2
}

require_command() {
    if ! command -v "$1" >/dev/null 2>&1; then
        error "Required command not found: $1"
        exit 1
    fi
}


# ============================================================
# CHECK DEPENDENCIES
# ============================================================

check_dependencies() {
    info "Checking dependencies..."

    require_command git
    require_command gdbus
    require_command alacritty
    require_command systemctl

    if ! command -v stow >/dev/null 2>&1; then
        info "GNU Stow is not installed; continuing without invoking it."
    fi

    success "Dependencies checked."
}


# ============================================================
# INSTALL THEME REPOSITORY
# ============================================================

install_themes() {
    info "Installing Alacritty themes..."

    mkdir -p "$ALACRITTY_DIR"

    if [[ ! -d "$THEMES_REPO/.git" ]]; then
        if [[ -e "$THEMES_REPO" ]]; then
            error "$THEMES_REPO exists but is not a Git repository."
            error "Move/remove it and run this installer again."
            exit 1
        fi

        git clone \
            --depth=1 \
            --filter=blob:none \
            --sparse \
            "$THEME_REPO_URL" \
            "$THEMES_REPO"

        cd "$THEMES_REPO"

        git sparse-checkout set --no-cone \
            '/themes/' \
            '/print_colors.sh'
    else
        cd "$THEMES_REPO"

        info "Updating existing Alacritty theme repository..."

        git sparse-checkout set --no-cone \
            '/themes/' \
            '/print_colors.sh'

        git pull --ff-only
    fi

    success "Alacritty themes installed."
}


# ============================================================
# VERIFY REQUIRED THEMES
# ============================================================

verify_themes() {
    info "Checking required themes..."

    local dark_theme
    local light_theme

    dark_theme="$THEMES_REPO/themes/tokyo_night_storm.toml"
    light_theme="$THEMES_REPO/themes/ashes_light.toml"

    if [[ ! -f "$dark_theme" ]]; then
        error "Missing dark theme: $dark_theme"
        exit 1
    fi

    if [[ ! -f "$light_theme" ]]; then
        error "Missing light theme: $light_theme"
        exit 1
    fi

    success "Required themes are available."
}


# ============================================================
# CREATE INITIAL ACTIVE THEME
# ============================================================

create_active_theme() {
    info "Setting default Alacritty theme..."

    local dark_theme
    dark_theme="$THEMES_REPO/themes/tokyo_night_storm.toml"

    rm -f "$ALACRITTY_DIR/active-theme.toml"

    ln -s "$dark_theme" "$ALACRITTY_DIR/active-theme.toml"

    success "Default theme: tokyo_night_storm"
}


# ============================================================
# INSTALL USER SCRIPTS
# ============================================================

install_scripts() {
    info "Installing Alacritty user scripts..."

    mkdir -p "$USER_BIN"

    for script in "$SCRIPTS_SOURCE"/*; do
        [[ -f "$script" ]] || continue

        local name
        name="$(basename "$script")"

        install -m 755 \
            "$script" \
            "$USER_BIN/$name"
    done

    success "User scripts installed in $USER_BIN."
}


# ============================================================
# INSTALL SYSTEMD SERVICE
# ============================================================

install_service() {
    info "Installing user systemd service..."

    mkdir -p "$SYSTEMD_USER_DIR"

    install -m 644 \
        "$SERVICE_SOURCE" \
        "$SYSTEMD_USER_DIR/alacritty-theme-sync.service"

    systemctl --user daemon-reload

    success "systemd service installed."
}


# ============================================================
# ENABLE SERVICE
# ============================================================

enable_service() {
    info "Enabling Alacritty theme watcher..."

    systemctl --user enable --now alacritty-theme-sync.service

    if systemctl --user is-active --quiet alacritty-theme-sync.service; then
        success "Alacritty theme watcher is running."
    else
        error "The Alacritty theme watcher failed to start."
        systemctl --user --no-pager --full status \
            alacritty-theme-sync.service || true
        exit 1
    fi
}


# ============================================================
# FINAL SYNC
# ============================================================

run_initial_sync() {
    info "Synchronizing with the current Plasma theme..."

    "$USER_BIN/alacritty-theme-sync"

    success "Initial theme synchronization complete."
}


# ============================================================
# MAIN
# ============================================================

main() {
    echo
    echo "Installing Alacritty configuration..."
    echo

    check_dependencies
    install_themes
    verify_themes
    create_active_theme
    install_scripts
    install_service
    enable_service
    run_initial_sync

    echo
    success "Alacritty configuration installed successfully."
    echo
    echo "Theme watcher:"
    echo "  systemctl --user status alacritty-theme-sync.service"
    echo
    echo "Theme watcher logs:"
    echo "  journalctl --user -u alacritty-theme-sync.service -f"
    echo
}

main "$@"

