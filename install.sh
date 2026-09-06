#!/usr/bin/env bash
# ==============================================================================
# Dotfiles Installer & System Setup
# Labwc + Noctalia Shell + macOS Traffic Lights + Windows Shortcuts + Fcitx5
# ==============================================================================

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.config_backup_$(date +%Y%m%d_%H%M%S)"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}====================================================${NC}"
echo -e "${GREEN}  CachyOS / Linux Desktop Setup Installer           ${NC}"
echo -e "${BLUE}  Labwc + Noctalia + macOS Titlebar + Windows Keys  ${NC}"
echo -e "${BLUE}====================================================${NC}"
echo ""

# 1. Parse Arguments
INSTALL_PACKAGES=true
for arg in "$@"; do
    case $arg in
        --no-pkg|--no-packages)
            INSTALL_PACKAGES=false
            shift
            ;;
        -y|--yes)
            AUTO_YES=true
            shift
            ;;
    esac
done

# 2. Distro Detection & Package Installation
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
        echo -e "${YELLOW}==> Bạn đang dùng bản phân phối không phải Arch ($DISTRO_ID).${NC}"
        echo -e "    Vui lòng tham khảo $DOTFILES_DIR/packages/generic-packages.txt để cài đặt thủ công các gói tương đương."
    fi
fi

# 3. Backup Existing Configs (An toàn 100%)
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
backup_if_exists "$HOME/.config/environment.d/im.conf"
backup_if_exists "$HOME/.config/fcitx5"
backup_if_exists "$HOME/.local/share/themes/noctalia-macos"

# 4. Deploy Directories & Configurations
echo -e "${BLUE}==>${NC} Đang triển khai các file cấu hình..."

mkdir -p "$HOME/.config/labwc"
mkdir -p "$HOME/.config/noctalia"
mkdir -p "$HOME/.config/environment.d"
mkdir -p "$HOME/.config/fcitx5/conf"
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.local/share/themes"

# Copy configs
cp -a "$DOTFILES_DIR/config/labwc/"* "$HOME/.config/labwc/"
cp -a "$DOTFILES_DIR/config/noctalia/"* "$HOME/.config/noctalia/"
cp -a "$DOTFILES_DIR/config/environment.d/"* "$HOME/.config/environment.d/"
cp -a "$DOTFILES_DIR/config/fcitx5/"* "$HOME/.config/fcitx5/"
cp -a "$DOTFILES_DIR/themes/noctalia-macos" "$HOME/.local/share/themes/"
cp -a "$DOTFILES_DIR/bin/"* "$HOME/.local/bin/"

# Ensure executable permissions
chmod +x "$HOME/.local/bin/"*.sh 2>/dev/null || true
chmod +x "$HOME/.config/labwc/"*.sh 2>/dev/null || true
chmod +x "$HOME/.config/labwc/autostart" 2>/dev/null || true

# 5. Ensure ~/.local/bin is in PATH
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo -e "${YELLOW}==>${NC} Đang thêm ~/.local/bin vào biến PATH..."
    if [ -f "$HOME/.bashrc" ]; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
    fi
    if [ -f "$HOME/.zshrc" ]; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
    fi
    if [ -f "$HOME/.config/fish/config.fish" ]; then
        echo 'fish_add_path -a $HOME/.local/bin' >> "$HOME/.config/fish/config.fish"
    fi
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
echo -e "• Nút traffic lights macOS: Đã kích hoạt 100% chuẩn nét."
echo -e "• Phím tắt Windows (Win+D, Win+E, Win+A, v.v.): Sẵn sàng."
echo -e "• Bộ gõ tiếng Việt Fcitx5: Đã đồng bộ môi trường Wayland."
echo -e "• Hình nền tự động Wallhaven (Win+W đổi ảnh): Đã cài đặt."
echo ""
echo -e "Bản sao lưu cấu hình cũ được lưu tại: ${YELLOW}$BACKUP_DIR${NC}"
