#!/bin/sh
# ==============================================================================
# Xử lý vuốt 3 ngón LÊN chuẩn Windows:
# - Nếu vừa thu nhỏ về Desktop: Khôi phục lại toàn bộ các cửa sổ (Restore Windows)
# - Nếu đang làm việc bình thường: Mở Task View / Thumbnail Switcher OSD
# ==============================================================================

# Tự động hết hạn cờ Desktop sau 60 giây nếu người dùng mở app bằng chuột
if [ -f /tmp/.labwc_desktop_mode ]; then
    now=$(date +%s)
    mod=$(stat -c %Y /tmp/.labwc_desktop_mode 2>/dev/null || echo "$now")
    if [ $((now - mod)) -gt 60 ]; then
        rm -f /tmp/.labwc_desktop_mode
    fi
fi

if [ -f /tmp/.labwc_desktop_mode ]; then
    # Khôi phục toàn bộ cửa sổ về vị trí cũ
    rm -f /tmp/.labwc_desktop_mode
    wtype -M logo -k d -m logo
else
    # Mở Task View dạng Thumbnail OSD xem & chuyển đổi ứng dụng
    wtype -M logo -k Tab
    sleep 0.8
    wtype -m logo
fi
