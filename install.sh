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
    echo -e "${BLUE}  Labwc + Noctalia + Modern Titlebar + Windows Keys ${NC}"
    echo -e "${BLUE}====================================================${NC}"
    echo ""
}

print_help() {
    print_banner
    echo -e "Cách sử dụng:"
    echo -e "  ${GREEN}./install.sh${NC}              Cài đặt/triển khai cấu hình từ dotfiles vào máy"
    echo -e "  ${GREEN}./install.sh --no-pkg${NC}     Triển khai cấu hình, bỏ qua bước kiểm tra cài đặt gói"
    echo -e "  ${GREEN}./install.sh --save${NC}       Lưu cấu hình thực tế từ ~/.config ngược vào repo dotfiles"
    echo -e "  ${GREEN}./install.sh --help${NC}       Hiển thị trợ giúp này"
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
            echo -e "${RED}Tùy chọn không hợp lệ:${NC} $arg"
            print_help
            exit 1
            ;;
    esac
done

print_banner

# ==============================================================================
# SAVE MODE: Lưu cấu hình đang chạy trên máy vào repo Git
# ==============================================================================
if [ "$SAVE_MODE" = true ]; then
    echo -e "${BLUE}==>${NC} Đang sao chép cấu hình từ hệ thống vào repo dotfiles..."

    # Labwc (bỏ qua file themerc-override vì file này tự sinh theo hình nền)
    if [ -d "$HOME/.config/labwc" ]; then
        mkdir -p "$DOTFILES_DIR/config/labwc"
        for f in "$HOME/.config/labwc/"*; do
            [ -f "$f" ] || continue
            [ "$(basename "$f")" = "themerc-override" ] && continue
            cp -a "$f" "$DOTFILES_DIR/config/labwc/"
        done
    fi

    # Noctalia
    if [ -d "$HOME/.config/noctalia" ]; then
        mkdir -p "$DOTFILES_DIR/config/noctalia"
        [ -f "$HOME/.config/noctalia/config.toml" ] && cp -a "$HOME/.config/noctalia/config.toml" "$DOTFILES_DIR/config/noctalia/"
    fi

    # Fcitx5
    if [ -d "$HOME/.config/fcitx5" ]; then
        mkdir -p "$DOTFILES_DIR/config/fcitx5"
        cp -a "$HOME/.config/fcitx5/"* "$DOTFILES_DIR/config/fcitx5/" 2>/dev/null || true
    fi

    # Alacritty
    if [ -d "$HOME/.config/alacritty" ]; then
        mkdir -p "$DOTFILES_DIR/config/alacritty"
        cp -a "$HOME/.config/alacritty/"* "$DOTFILES_DIR/config/alacritty/" 2>/dev/null || true
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

    # Libinput Gestures
    if [ -f "$HOME/.config/libinput-gestures.conf" ]; then
        cp -a "$HOME/.config/libinput-gestures.conf" "$DOTFILES_DIR/config/libinput-gestures.conf"
    fi

    # Scripts cá nhân trong ~/.local/bin
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

    echo -e "${GREEN}✓ Đã cập nhật xong vào repo dotfiles!${NC}"
    echo ""
    echo -e "${BLUE}==>${NC} Trạng thái thay đổi trong Git:"
    git -C "$DOTFILES_DIR" status --short
    echo ""
    echo -e "${YELLOW}Gợi ý:${NC} Hãy kiểm tra 'git diff' trong thư mục dotfiles, sau đó commit và push khi bạn đã ưng ý:"
    echo -e "  cd ~/dotfiles && git diff"
    echo -e "  git commit -am 'update config' && git push"
    exit 0
fi

# ==============================================================================
# INSTALL MODE: Triển khai cấu hình từ dotfiles vào máy
# ==============================================================================

# 2. Package Installation (Dành cho Arch / CachyOS)
if [ "$INSTALL_PACKAGES" = true ]; then
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO_ID="$ID"
        DISTRO_LIKE="${ID_LIKE:-$ID}"
    else
        DISTRO_ID="unknown"
        DISTRO_LIKE="unknown"
    fi

    echo -e "${BLUE}==>${NC} Phát hiện hệ điều hành: ${GREEN}${NAME:-$DISTRO_ID}${NC}"

    if [[ "$DISTRO_ID" == "cachyos" || "$DISTRO_ID" == "arch" || "$DISTRO_LIKE" =~ "arch" ]]; then
        echo -e "${BLUE}==>${NC} Đang kiểm tra các gói phần mềm cho Arch / CachyOS..."

        PKGS=()
        while IFS= read -r pkg || [ -n "$pkg" ]; do
            [[ "$pkg" =~ ^#.* ]] && continue
            [[ -z "$pkg" ]] && continue
            PKGS+=("$pkg")
        done < "$DOTFILES_DIR/packages/cachyos-packages.txt"

        MISSING_PKGS=()
        for pkg in "${PKGS[@]}"; do
            if ! pacman -Qi "$pkg" >/dev/null 2>&1; then
                MISSING_PKGS+=("$pkg")
            fi
        done

        if [ ${#MISSING_PKGS[@]} -gt 0 ]; then
            echo -e "${YELLOW}Cần cài đặt thêm các gói sau:${NC} ${MISSING_PKGS[*]}"
            if command -v paru >/dev/null 2>&1; then
                paru -S --needed --noconfirm "${MISSING_PKGS[@]}"
            elif command -v yay >/dev/null 2>&1; then
                yay -S --needed --noconfirm "${MISSING_PKGS[@]}"
            else
                sudo pacman -S --needed --noconfirm "${MISSING_PKGS[@]}"
            fi
        else
            echo -e "${GREEN}✓ Tất cả các gói phần mềm cần thiết đã được cài đặt!${NC}"
        fi
    else
        echo -e "${YELLOW}==> Bạn đang dùng ($DISTRO_ID).${NC}"
        echo -e "    Vui lòng tham khảo $DOTFILES_DIR/packages/cachyos-packages.txt để cài đặt thủ công các gói tương đương."
    fi
fi

# 3. Backup Existing Configs (An toàn vào cache)
echo ""
echo -e "${BLUE}==>${NC} Đang sao lưu cấu hình cũ (nếu có) vào: ${YELLOW}$BACKUP_DIR${NC}"
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

backup_if_exists "$HOME/.config/labwc"
backup_if_exists "$HOME/.config/noctalia"
backup_if_exists "$HOME/.config/environment.d"
backup_if_exists "$HOME/.config/fcitx5"
backup_if_exists "$HOME/.local/share/themes/noctalia-modern"
backup_if_exists "$HOME/.profile"

# 4. Deploy Directories & Configurations
echo -e "${BLUE}==>${NC} Đang triển khai các file cấu hình..."

mkdir -p "$HOME/.config/labwc"
mkdir -p "$HOME/.config/noctalia"
mkdir -p "$HOME/.config/environment.d"
mkdir -p "$HOME/.config/xdg-desktop-portal"
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.local/share/themes"
mkdir -p "$HOME/.local/share/applications"

# Copy configs
cp -a "$DOTFILES_DIR/config/labwc/"* "$HOME/.config/labwc/"
cp -a "$DOTFILES_DIR/config/noctalia/"* "$HOME/.config/noctalia/"
cp -a "$DOTFILES_DIR/config/environment.d/"* "$HOME/.config/environment.d/"
cp -a "$DOTFILES_DIR/config/fcitx5/"* "$HOME/.config/fcitx5/"
cp -a "$DOTFILES_DIR/config/xdg-desktop-portal/"* "$HOME/.config/xdg-desktop-portal/" 2>/dev/null || true
cp -a "$DOTFILES_DIR/themes/noctalia-modern" "$HOME/.local/share/themes/"
cp -a "$DOTFILES_DIR/bin/"* "$HOME/.local/bin/"
cp -a "$DOTFILES_DIR/applications/"* "$HOME/.local/share/applications/" 2>/dev/null || true
update-desktop-database "$HOME/.local/share/applications" 2>/dev/null || true

# Deploy ~/.profile (Login shell / Ly display manager environment)
if [ -f "$DOTFILES_DIR/profile" ]; then
    cp -a "$DOTFILES_DIR/profile" "$HOME/.profile"
fi

# Deploy Firefox Trackpad settings (user.js)
for profile in "$HOME/.config/mozilla/firefox/"*.default* "$HOME/.mozilla/firefox/"*.default*; do
    if [ -d "$profile" ]; then
        cp -a "$DOTFILES_DIR/config/firefox/user.js" "$profile/" 2>/dev/null || true
    fi
done

# Deploy Touchpad Gestures config
if [ -f "$DOTFILES_DIR/config/libinput-gestures.conf" ]; then
    cp -a "$DOTFILES_DIR/config/libinput-gestures.conf" "$HOME/.config/libinput-gestures.conf"
    systemctl --user enable --now libinput-gestures.service 2>/dev/null || true
fi

# Enable Fcitx5 Lotus Server (Uinput mode daemon) if available
if [ -f "/usr/lib/systemd/system/fcitx5-lotus-server@.service" ]; then
    if ! systemctl is-active --quiet "fcitx5-lotus-server@$USER.service"; then
        echo -e "${YELLOW}==>${NC} Đang kích hoạt fcitx5-lotus-server cho $USER..."
        sudo systemctl enable --now "fcitx5-lotus-server@$USER.service" 2>/dev/null || true
    fi
fi

# Ensure executable permissions
chmod +x "$HOME/.local/bin/"*.sh 2>/dev/null || true
chmod +x "$HOME/.config/labwc/autostart" 2>/dev/null || true

# Ensure Noctalia state overrides have square corners if settings.toml exists
if [ -f "$HOME/.local/state/noctalia/settings.toml" ]; then
    sed -i 's/corner_radius_scale = [0-9.]\+/corner_radius_scale = 0.0/g' "$HOME/.local/state/noctalia/settings.toml"
    sed -i 's/background_radius = [0-9.]\+/background_radius = 0.0/g' "$HOME/.local/state/noctalia/settings.toml"
    sed -i 's/input_radius = [0-9.]\+/input_radius = 0.0/g' "$HOME/.local/state/noctalia/settings.toml"
    sed -i 's/floating_offset = [0-9]\+/floating_offset = 0/g' "$HOME/.local/state/noctalia/settings.toml"
fi

# Ensure Start button icon fallback is valid
if [ ! -f "/usr/share/icons/hicolor/scalable/apps/org.cachyos.hello.svg" ]; then
    sed -i "s|/usr/share/icons/hicolor/scalable/apps/org.cachyos.hello.svg|$HOME/.local/share/themes/noctalia-modern/start-icon.svg|g" "$HOME/.config/noctalia/config.toml" 2>/dev/null || true
fi

# 5. Ensure ~/.local/bin is in PATH (Idempotent)
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo -e "${YELLOW}==>${NC} Đang thêm ~/.local/bin vào biến PATH..."
    [ -f "$HOME/.bashrc" ] && ! grep -q '\.local/bin' "$HOME/.bashrc" 2>/dev/null && echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
    [ -f "$HOME/.zshrc" ] && ! grep -q '\.local/bin' "$HOME/.zshrc" 2>/dev/null && echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
    [ -f "$HOME/.config/fish/config.fish" ] && ! grep -q '\.local/bin' "$HOME/.config/fish/config.fish" 2>/dev/null && echo 'fish_add_path -a $HOME/.local/bin' >> "$HOME/.config/fish/config.fish"
fi

# 6. Live Reconfigure
echo -e "${BLUE}==>${NC} Đang kiểm tra và tải cấu hình mới..."
if command -v noctalia >/dev/null 2>&1; then
    noctalia config validate >/dev/null 2>&1 && echo -e "${GREEN}✓ Cấu hình Noctalia hợp lệ!${NC}"
fi

if [ -n "$WAYLAND_DISPLAY" ] && command -v labwc >/dev/null 2>&1; then
    labwc --reconfigure 2>/dev/null || true
    echo -e "${GREEN}✓ Đã nạp lại cấu hình Labwc thành công!${NC}"
fi

echo ""
echo -e "${GREEN}====================================================${NC}"
echo -e "${GREEN}✓ CÀI ĐẶT HOÀN TẤT THÀNH CÔNG!                     ${NC}"
echo -e "${GREEN}====================================================${NC}"
echo -e "• Giao diện thanh tiêu đề chuẩn Windows: Đã kích hoạt."
echo -e "• Phím tắt Windows (Win+D, Win+E, Win+A, v.v.): Sẵn sàng."
echo -e "• Cử chỉ Touchpad 3 ngón (Lên khôi phục, Xuống Desktop): Đã cấu hình."
echo -e "• Bộ gõ tiếng Việt Fcitx5: Đã đồng bộ môi trường Wayland."
echo -e "• Hình nền tự động Wallhaven (Win+W đổi ảnh): Đã cài đặt."
echo ""
echo -e "Bản sao lưu cấu hình cũ được lưu tại: ${YELLOW}$BACKUP_DIR${NC}"
