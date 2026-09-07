#!/bin/sh
# ==============================================================================
# Xử lý vuốt 3 ngón LÊN:
# - Nếu vừa ở Desktop (vừa vuốt xuống): Khôi phục lại toàn bộ cửa sổ
# - Nếu đang làm việc bình thường: Mở Task View Thumbnail OSD (không cướp tiêu điểm)
# ==============================================================================

# Xóa cờ nếu đã quá 60s
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
    # Mở Task View Thumbnail OSD để quan sát các app đang mở
    # Giữ nguyên cửa sổ hiện tại, không tự động cướp tiêu điểm chuyển sang app khác
    wtype -M logo -k Tab -M shift -k Tab -m shift
    sleep 1.2
    wtype -m logo
fi
