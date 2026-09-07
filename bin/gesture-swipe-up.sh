#!/bin/sh
# ==============================================================================
# Xử lý vuốt 3 ngón LÊN:
# - Nếu đang ở Desktop (vừa vuốt xuống): Khôi phục lại toàn bộ cửa sổ
# - Nếu cửa sổ đã mở sẵn: Giữ nguyên, không làm gì (không hiện popup/preview)
# ==============================================================================

# Xóa cờ nếu đã quá 60 giây
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
fi
