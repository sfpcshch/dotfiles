#!/usr/bin/env bash
# ==============================================================================
# Bảng tra cứu phím tắt nhanh (Keyboard Shortcuts Cheat Sheet)
# Hiển thị đẹp mắt theo bảng mã màu Noctalia trong cửa sổ nổi Alacritty
# ==============================================================================

# Nếu script không chạy trong terminal Alacritty nổi, tự động gọi Alacritty
if [ -z "$KEYBINDS_HELPER_INTERNAL" ]; then
    export KEYBINDS_HELPER_INTERNAL=1
    exec alacritty --class "KeybindsHelp,Alacritty" \
                   -T "Bảng Phím Tắt Hệ Thống (Shortcuts Cheat Sheet)" \
                   -o "window.dimensions={columns=74,lines=31}" \
                   -e bash "$0"
    exit 0
fi

# Màu ANSI đồng bộ Noctalia
GREEN="\033[38;2;177;209;131m"
BLUE="\033[38;2;131;215;181m"
YELLOW="\033[38;2;190;204;166m"
WHITE="\033[38;2;227;227;218m"
BOLD="\033[1m"
DIM="\033[2m"
NC="\033[0m"

clear
echo -e "${BOLD}${GREEN}╔════════════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${GREEN}║                     ⌨️  BẢNG PHÍM TẮT HỆ THỐNG                         ║${NC}"
echo -e "${BOLD}${GREEN}╠════════════════════════════════════════════════════════════════════════╣${NC}"
echo -e "${BOLD}${BLUE}  1. Quản lý Cửa sổ & Đa nhiệm:${NC}"
echo -e "     ${YELLOW}Win + Tab${NC} / ${YELLOW}Alt + Tab${NC}   : Chuyển cửa sổ (Thumbnail Task View OSD)"
echo -e "     ${YELLOW}Win + Q${NC} / ${YELLOW}Alt + F4${NC}     : Đóng cửa sổ hiện tại (Close window)"
echo -e "     ${YELLOW}Win + F${NC}               : Bật / Tắt Toàn màn hình (Toggle Fullscreen)"
echo -e "     ${YELLOW}Win + D${NC}               : Thu nhỏ tất cả / Hiện Desktop"
echo -e "     ${YELLOW}Win + Mũi tên Lên${NC}     : Phóng to cực đại cửa sổ (Maximize)"
echo -e "     ${YELLOW}Win + Mũi tên Xuống${NC}   : Thu nhỏ cửa sổ xuống Taskbar (Iconify)"
echo -e "     ${YELLOW}Win + Mũi tên Trái/Phải${NC}: Snap chia nửa màn hình Trái / Phải"
echo ""
echo -e "${BOLD}${BLUE}  2. Ứng dụng Thường Dùng:${NC}"
echo -e "     ${YELLOW}Win${NC} / ${YELLOW}Win + Space${NC}      : Start Menu (Tìm kiếm & mở ứng dụng nhanh)"
echo -e "     ${YELLOW}Win + B${NC}               : Trình duyệt Web (Brave Browser)"
echo -e "     ${YELLOW}Win + E${NC}               : Quản lý tệp tin File Manager (Dolphin)"
echo -e "     ${YELLOW}Win + Enter${NC} / ${YELLOW}Win + T${NC}  : Cửa sổ lệnh Terminal (Alacritty)"
echo -e "     ${YELLOW}Ctrl + Shift + Esc${NC}    : Trình quản lý tác vụ Task Manager (btop)"
echo ""
echo -e "${BOLD}${BLUE}  3. Tiện ích Hệ Thống & Shell (Noctalia):${NC}"
echo -e "     ${YELLOW}Win + I${NC} / ${YELLOW}Win + S${NC}       : Bật / Tắt Cài đặt hệ thống (Settings)"
echo -e "     ${YELLOW}Win + A${NC}               : Action Center / Quick Settings (Wifi, Âm lượng...)"
echo -e "     ${YELLOW}Win + N${NC}               : Trung tâm Thông báo (Notifications)"
echo -e "     ${YELLOW}Win + V${NC}               : Bảng lịch sử Clipboard (Bộ nhớ tạm)"
echo -e "     ${YELLOW}Win + L${NC}               : Khóa màn hình (Lock screen)"
echo -e "     ${YELLOW}Win + X${NC}               : Bảng điều khiển Nguồn (Tắt máy, Khởi động lại)"
echo -e "     ${YELLOW}Win + W${NC} / ${YELLOW}Win + S-W${NC}   : Đổi hình nền Tiếp theo / Lùi lại (Wallhaven)"
echo -e "     ${YELLOW}Win + Shift + S${NC}       : Chụp ảnh màn hình vùng chọn (Snipping Tool)"
echo -e "     ${YELLOW}Win + /${NC} hoặc ${YELLOW}Win + ?${NC}   : Mở bảng tra cứu phím tắt này"
echo -e "${BOLD}${GREEN}╚════════════════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "  ${DIM}Nhấn phím bất kỳ (hoặc Esc / q) để đóng bảng...${NC}"

# Đọc 1 ký tự bất kỳ rồi thoát
read -rsn1 -t 60 2>/dev/null || true
