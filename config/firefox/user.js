// ==============================================================================
// Firefox Trackpad & Mouse Wheel Optimization (Windows-style behavior)
// ==============================================================================

// 1. Mouse Wheel Scrolling Speed
// Fix Linux slow mouse wheel scrolling (raise from default 3 lines to 25 lines per notch)
user_pref("mousewheel.min_line_scroll_amount", 25);
user_pref("mousewheel.system_scroll_override.enabled", true);

// 2. Trackpad scroll multiplier
// Compensates for compositor scrollFactor 0.55 for smooth and responsive scrolling
user_pref("mousewheel.default.delta_multiplier_y", 160);

// 3. Kinetic Inertial Scrolling on Wayland
user_pref("apz.gtk.kinetic_scroll.enabled", true);
user_pref("apz.gtk.touchpad_hold.enabled", true); // Placing fingers back on touchpad stops scroll immediately
user_pref("general.smoothScroll", true);

// 4. Momentum and Fling Curves
user_pref("apz.fling_friction", "0.0018");
user_pref("apz.max_velocity_inches_per_ms", "0.25");

// 5. Pinch-to-zoom (2-finger zoom gesture)
user_pref("apz.allow_zooming", true);
user_pref("browser.gesture.pinch.in", "cmd_fullZoomReduce");
user_pref("browser.gesture.pinch.out", "cmd_fullZoomEnlarge");
user_pref("browser.gesture.pinch.latched", false);

// 6. Horizontal 2-finger swipe for Back / Forward navigation
user_pref("browser.gesture.swipe.left", "Browser:Back");
user_pref("browser.gesture.swipe.right", "Browser:Forward");
