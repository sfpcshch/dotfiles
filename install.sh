#!/usr/bin/env bash
# ==============================================================================
# Dotfiles Installer & Configuration Sync
# Labwc + Noctalia Shell + Windows-style Desktop + Fcitx5 (Arch / CachyOS)
# ==============================================================================

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}"
BACKUP_DIR="$CACHE_DIR/dotfiles-backup/$(date +%Y%m%d_%H%M%S)"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

print_banner() {
    echo -e "${BLUE}====================================================${NC}"
    echo -e "${GREEN}  CachyOS / Arch Linux Desktop Setup & Dotfiles     ${NC}"
    echo -e "${BLUE}  Labwc + Noctalia + Starship + Windows-style Keys  ${NC}"
    echo -e "${BLUE}====================================================${NC}"
    echo ""
}

print_help() {
    print_banner
    echo -e "Usage:"
    echo -e "  ${GREEN}./install.sh${NC}              Deploy dotfiles configuration to the system"
    echo -e "  ${GREEN}./install.sh --no-pkg${NC}     Deploy configuration, skip package verification"
    echo -e "  ${GREEN}./install.sh --save${NC}       Save active configs from ~/.config into dotfiles repo"
    echo -e "  ${GREEN}./install.sh --help${NC}       Show this help message"
    echo ""
}

# 1. Parse Arguments
INSTALL_PACKAGES=true
SAVE_MODE=false

for arg in "$@"; do
    case $arg in
        --no-pkg|--no-packages)
            INSTALL_PACKAGES=false
            ;;
        --save|-s)
            SAVE_MODE=true
            ;;
        --help|-h)
            print_help
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option:${NC} $arg"
            print_help
            exit 1
            ;;
    esac
done

print_banner

# ==============================================================================
# SAVE MODE: Save running system configs back into Git repository
# ==============================================================================
if [ "$SAVE_MODE" = true ]; then
    echo -e "${BLUE}==>${NC} Saving active configurations into dotfiles repository..."

    # Labwc (skip themerc-override & noctalia.conf as they are auto-generated from wallpaper)
    if [ -d "$HOME/.config/labwc" ]; then
        mkdir -p "$DOTFILES_DIR/config/labwc"
        for f in "$HOME/.config/labwc/"*; do
            [ -f "$f" ] || continue
            case "$(basename "$f")" in
                themerc-override|noctalia.conf) continue ;;
            esac
            cp -a "$f" "$DOTFILES_DIR/config/labwc/"
        done
    fi

    # Noctalia (config.toml and user theme templates)
    if [ -d "$HOME/.config/noctalia" ]; then
        mkdir -p "$DOTFILES_DIR/config/noctalia"
        [ -f "$HOME/.config/noctalia/config.toml" ] && cp -a "$HOME/.config/noctalia/config.toml" "$DOTFILES_DIR/config/noctalia/"
        if [ -d "$HOME/.config/noctalia/templates" ]; then
            mkdir -p "$DOTFILES_DIR/config/noctalia/templates"
            cp -a "$HOME/.config/noctalia/templates/"* "$DOTFILES_DIR/config/noctalia/templates/" 2>/dev/null || true
        fi
    fi

    # Fcitx5
    if [ -d "$HOME/.config/fcitx5" ]; then
        mkdir -p "$DOTFILES_DIR/config/fcitx5"
        cp -a "$HOME/.config/fcitx5/"* "$DOTFILES_DIR/config/fcitx5/" 2>/dev/null || true
    fi

    # Alacritty
    if [ -d "$HOME/.config/alacritty" ]; then
        mkdir -p "$DOTFILES_DIR/config/alacritty"
        for f in "$HOME/.config/alacritty/"*; do
            [ -e "$f" ] || continue
            [ "$(basename "$f")" = "themes" ] && continue
            cp -a "$f" "$DOTFILES_DIR/config/alacritty/"
        done
    fi

    # Environment.d
    if [ -d "$HOME/.config/environment.d" ]; then
        mkdir -p "$DOTFILES_DIR/config/environment.d"
        cp -a "$HOME/.config/environment.d/"* "$DOTFILES_DIR/config/environment.d/" 2>/dev/null || true
    fi

    # XDG Desktop Portal
    if [ -d "$HOME/.config/xdg-desktop-portal" ]; then
        mkdir -p "$DOTFILES_DIR/config/xdg-desktop-portal"
        cp -a "$HOME/.config/xdg-desktop-portal/"* "$DOTFILES_DIR/config/xdg-desktop-portal/" 2>/dev/null || true
    fi

    # Fastfetch
    if [ -d "$HOME/.config/fastfetch" ]; then
        mkdir -p "$DOTFILES_DIR/config/fastfetch"
        for f in "$HOME/.config/fastfetch/"*; do
            [ -e "$f" ] || continue
            [ "$(basename "$f")" = "themes" ] && continue
            cp -a "$f" "$DOTFILES_DIR/config/fastfetch/"
        done
    fi

    # Starship Prompt
    if [ -f "$HOME/.config/starship.toml" ]; then
        cp -a "$HOME/.config/starship.toml" "$DOTFILES_DIR/config/starship.toml"
    fi

    # Fish Shell
    if [ -d "$HOME/.config/fish" ]; then
        mkdir -p "$DOTFILES_DIR/config/fish"
        [ -f "$HOME/.config/fish/config.fish" ] && cp -a "$HOME/.config/fish/config.fish" "$DOTFILES_DIR/config/fish/"
    fi

    # Personal user scripts in ~/.local/bin
    if [ -d "$HOME/.local/bin" ]; then
        mkdir -p "$DOTFILES_DIR/bin"
        for s in "$HOME/.local/bin/"*.sh "$HOME/.local/bin/xdg-terminal-exec"; do
            [ -f "$s" ] && cp -a "$s" "$DOTFILES_DIR/bin/"
        done
    fi

    # ~/.profile
    if [ -f "$HOME/.profile" ]; then
        cp -a "$HOME/.profile" "$DOTFILES_DIR/profile"
    fi

    # Applications (.desktop files) - Whitelist to prevent directory pollution
    if [ -d "$DOTFILES_DIR/applications" ] && [ -d "$HOME/.local/share/applications" ]; then
        for app in "$DOTFILES_DIR/applications/"*.desktop; do
            [ -f "$app" ] || continue
            base="$(basename "$app")"
            [ -f "$HOME/.local/share/applications/$base" ] && cp -a "$HOME/.local/share/applications/$base" "$DOTFILES_DIR/applications/"
        done
    fi

    echo -e "${GREEN}✓ Dotfiles repository successfully updated!${NC}"
    echo ""
    echo -e "${BLUE}==>${NC} Git working tree status:"
    git -C "$DOTFILES_DIR" status --short
    echo ""
    echo -e "${YELLOW}Hint:${NC} Review changes with 'git diff', then commit and push:"
    echo -e "  cd ~/dotfiles && git diff"
    echo -e "  git commit -am 'update config' && git push"
    exit 0
fi

# ==============================================================================
# INSTALL MODE: Deploy configuration files to system
# ==============================================================================

# 2. Package Installation (Arch / CachyOS)
if [ "$INSTALL_PACKAGES" = true ]; then
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO_ID="$ID"
        DISTRO_LIKE="${ID_LIKE:-$ID}"
    else
        DISTRO_ID="unknown"
        DISTRO_LIKE="unknown"
    fi

    echo -e "${BLUE}==>${NC} Detected operating system: ${GREEN}${NAME:-$DISTRO_ID}${NC}"

    if [[ "$DISTRO_ID" == "cachyos" || "$DISTRO_ID" == "arch" || "$DISTRO_LIKE" =~ "arch" ]]; then
        echo -e "${BLUE}==>${NC} Verifying package dependencies for Arch / CachyOS..."

        PKGS=()
        while IFS= read -r pkg || [ -n "$pkg" ]; do
            [[ "$pkg" =~ ^#.* ]] && continue
            [[ -z "$pkg" ]] && continue
            PKGS+=("$pkg")
        done < "$DOTFILES_DIR/packages/cachyos-packages.txt"

        MISSING_PKGS=()
        if [ ${#PKGS[@]} -gt 0 ]; then
            mapfile -t MISSING_PKGS < <(pacman -T "${PKGS[@]}" 2>/dev/null || true)
        fi

        if [ ${#MISSING_PKGS[@]} -gt 0 ]; then
            echo -e "${YELLOW}Packages to install:${NC} ${MISSING_PKGS[*]}"
            if command -v paru >/dev/null 2>&1; then
                paru -S --needed --noconfirm "${MISSING_PKGS[@]}"
            elif command -v yay >/dev/null 2>&1; then
                yay -S --needed --noconfirm "${MISSING_PKGS[@]}"
            else
                sudo pacman -S --needed --noconfirm "${MISSING_PKGS[@]}"
            fi
        else
            echo -e "${GREEN}✓ All required software packages are installed!${NC}"
        fi
    else
        echo -e "${YELLOW}==> Running on ($DISTRO_ID).${NC}"
        echo -e "    Please refer to $DOTFILES_DIR/packages/cachyos-packages.txt for equivalent packages."
    fi
fi

# 3. Backup Existing Configs safely to cache
echo ""
echo -e "${BLUE}==>${NC} Backing up existing configurations to: ${YELLOW}$BACKUP_DIR${NC}"
mkdir -p "$BACKUP_DIR"

backup_if_exists() {
    local target="$1"
    if [ -e "$target" ]; then
        local rel_path="${target#$HOME/}"
        local dest="$BACKUP_DIR/$rel_path"
        mkdir -p "$(dirname "$dest")"
        cp -a "$target" "$dest"
    fi
}

backup_if_exists "$HOME/.config/alacritty"
backup_if_exists "$HOME/.config/labwc"
backup_if_exists "$HOME/.config/noctalia"
backup_if_exists "$HOME/.config/environment.d"
backup_if_exists "$HOME/.config/xdg-desktop-portal"
backup_if_exists "$HOME/.config/fcitx5"
backup_if_exists "$HOME/.config/fastfetch"
backup_if_exists "$HOME/.config/starship.toml"
backup_if_exists "$HOME/.config/fish/config.fish"
backup_if_exists "$HOME/.local/share/themes/noctalia"
backup_if_exists "$HOME/.profile"

# 4. Deploy Directories & Configurations
echo -e "${BLUE}==>${NC} Deploying configuration files..."

mkdir -p "$HOME/.config/alacritty"
mkdir -p "$HOME/.config/labwc"
mkdir -p "$HOME/.config/noctalia"
mkdir -p "$HOME/.config/environment.d"
mkdir -p "$HOME/.config/xdg-desktop-portal"
mkdir -p "$HOME/.config/fastfetch"
mkdir -p "$HOME/.config/fish"
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.local/share/themes"
mkdir -p "$HOME/.local/share/applications"

# Copy configs
if [ -d "$DOTFILES_DIR/config/alacritty" ]; then
    for f in "$DOTFILES_DIR/config/alacritty/"*; do
        [ -e "$f" ] || continue
        [ "$(basename "$f")" = "themes" ] && continue
        cp -a "$f" "$HOME/.config/alacritty/"
    done
fi
cp -a "$DOTFILES_DIR/config/labwc/"* "$HOME/.config/labwc/"
cp -a "$DOTFILES_DIR/config/noctalia/"* "$HOME/.config/noctalia/"
cp -a "$DOTFILES_DIR/config/environment.d/"* "$HOME/.config/environment.d/"
cp -a "$DOTFILES_DIR/config/fcitx5/"* "$HOME/.config/fcitx5/"
cp -a "$DOTFILES_DIR/config/xdg-desktop-portal/"* "$HOME/.config/xdg-desktop-portal/" 2>/dev/null || true
[ -d "$DOTFILES_DIR/config/fastfetch" ] && cp -a "$DOTFILES_DIR/config/fastfetch/"* "$HOME/.config/fastfetch/" 2>/dev/null || true
[ -f "$DOTFILES_DIR/config/starship.toml" ] && cp -a "$DOTFILES_DIR/config/starship.toml" "$HOME/.config/starship.toml"
[ -f "$DOTFILES_DIR/config/fish/config.fish" ] && cp -a "$DOTFILES_DIR/config/fish/config.fish" "$HOME/.config/fish/config.fish"
cp -a "$DOTFILES_DIR/themes/noctalia" "$HOME/.local/share/themes/"
cp -a "$DOTFILES_DIR/bin/"* "$HOME/.local/bin/"
cp -a "$DOTFILES_DIR/applications/"* "$HOME/.local/share/applications/" 2>/dev/null || true
update-desktop-database "$HOME/.local/share/applications" 2>/dev/null || true

# Deploy ~/.profile (Login shell / Ly display manager environment)
if [ -f "$DOTFILES_DIR/profile" ]; then
    cp -a "$DOTFILES_DIR/profile" "$HOME/.profile"
fi

# Ensure executable permissions
chmod +x "$HOME/.local/bin/"*.sh 2>/dev/null || true
chmod +x "$HOME/.config/labwc/autostart" 2>/dev/null || true

# Ensure Noctalia state overrides have square corners if settings.toml exists
if [ -f "$HOME/.local/state/noctalia/settings.toml" ]; then
    sed -i \
        -e 's/corner_radius_scale = [0-9.]\+/corner_radius_scale = 0.0/g' \
        -e 's/background_radius = [0-9.]\+/background_radius = 0.0/g' \
        -e 's/input_radius = [0-9.]\+/input_radius = 0.0/g' \
        -e 's/floating_offset = [0-9]\+/floating_offset = 0/g' \
        "$HOME/.local/state/noctalia/settings.toml"
fi

# 5. Ensure ~/.local/bin is in PATH (Idempotent)
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo -e "${YELLOW}==>${NC} Adding ~/.local/bin to PATH variable..."
    [ -f "$HOME/.bashrc" ] && ! grep -q '\.local/bin' "$HOME/.bashrc" 2>/dev/null && echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
    [ -f "$HOME/.zshrc" ] && ! grep -q '\.local/bin' "$HOME/.zshrc" 2>/dev/null && echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
    [ -f "$HOME/.config/fish/config.fish" ] && ! grep -q '\.local/bin' "$HOME/.config/fish/config.fish" 2>/dev/null && echo 'fish_add_path -a $HOME/.local/bin' >> "$HOME/.config/fish/config.fish"
fi

# 6. Live Reconfigure
echo -e "${BLUE}==>${NC} Validating and reloading configuration..."
if command -v noctalia >/dev/null 2>&1; then
    noctalia config validate >/dev/null 2>&1 && echo -e "${GREEN}✓ Noctalia configuration is valid!${NC}"
fi

if [ -n "$WAYLAND_DISPLAY" ] && command -v labwc >/dev/null 2>&1; then
    labwc --reconfigure 2>/dev/null || true
    echo -e "${GREEN}✓ Labwc configuration reloaded successfully!${NC}"
fi

echo ""
echo -e "${GREEN}====================================================${NC}"
echo -e "${GREEN}✓ INSTALLATION COMPLETED SUCCESSFULLY!              ${NC}"
echo -e "${GREEN}====================================================${NC}"
echo -e "• Sharp titlebar theme: Active."
echo -e "• Windows-style shortcuts (Win+D, Win+E, Win+A, etc.): Ready."
echo -e "• Natural touchpad gestures: Configured."
echo -e "• Starship Powerline prompt with Noctalia palette: Ready."
echo -e "• Automated Wallhaven wallpaper cycling (Win+W): Installed."
echo ""
echo -e "Configuration backup saved at: ${YELLOW}$BACKUP_DIR${NC}"
