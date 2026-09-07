// ==============================================================================
// Tối ưu hóa Cuộn Trackpad & Bánh xe Chuột chuẩn Windows cho Firefox
// ==============================================================================

// 1. Tốc độ bánh xe chuột rời (Mouse Wheel) - Giải quyết dứt điểm lỗi lăn chuột quá chậm trên Linux
// Mặc định Linux chỉ cuộn 3-5 dòng/nấc. Nâng lên 25 dòng/nấc để lướt nhanh như Windows / Chromium
user_pref("mousewheel.min_line_scroll_amount", 25);
user_pref("mousewheel.system_scroll_override.enabled", true);

// 2. Độ nhạy cuộn bàn rê cảm ứng (Trackpad)
// Bù trừ tỷ lệ scrollFactor 0.55 từ compositor để Firefox giữ được độ lướt nhạy và mượt
user_pref("mousewheel.default.delta_multiplier_y", 160);

// 3. Kích hoạt cuộn có quán tính (Kinetic Inertial Scrolling) cho Wayland
user_pref("apz.gtk.kinetic_scroll.enabled", true);
user_pref("apz.gtk.touchpad_hold.enabled", true); // Đặt lại ngón tay lên trackpad là dừng cuộn ngay lập tức
user_pref("general.smoothScroll", true);

// 4. Gia tốc khi vuốt nhanh (Fling & Momentum Curves)
// Giảm ma sát để khi vuốt nhanh thì trang lướt xa và trôi mượt mà hơn
user_pref("apz.fling_friction", "0.0018");
// Tăng trần vận tốc tối đa để khi hất tay mạnh thì trang lướt xa hơn đáng kể
user_pref("apz.max_velocity_inches_per_ms", "0.25");

// 5. Cử chỉ Pinch-to-zoom (phóng to / thu nhỏ bằng 2 ngón)
user_pref("apz.allow_zooming", true);
user_pref("browser.gesture.pinch.in", "cmd_fullZoomReduce");
user_pref("browser.gesture.pinch.out", "cmd_fullZoomEnlarge");
user_pref("browser.gesture.pinch.latched", false);

// 6. Cử chỉ vuốt 2 ngón ngang sang trái/phải để Back / Forward
user_pref("browser.gesture.swipe.left", "Browser:Back");
user_pref("browser.gesture.swipe.right", "Browser:Forward");
