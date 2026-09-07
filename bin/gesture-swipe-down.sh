#!/bin/sh
# ==============================================================================
# Xử lý vuốt 3 ngón XUỐNG chuẩn Windows:
# Thu nhỏ toàn bộ cửa sổ để Hiện Desktop (Show Desktop)
# ==============================================================================

# Nếu chưa ở chế độ desktop thì thu nhỏ tất cả
if [ ! -f /tmp/.labwc_desktop_mode ]; then
    if command -v wtype >/dev/null 2>&1; then
        wtype -M logo -k d -m logo
        touch /tmp/.labwc_desktop_mode
    fi
fi
