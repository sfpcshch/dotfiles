#!/bin/bash
# ==============================================================================
# Đồng bộ màu Labwc Menu & OSD với bảng màu Noctalia (Material You)
# ==============================================================================

CSS="$HOME/.config/gtk-3.0/noctalia.css"
THEMERC="$HOME/.config/labwc/themerc-override"

if [ -f "$CSS" ]; then
    bg=$(grep "@define-color popover_bg_color" "$CSS" | awk '{print $3}' | tr -d ';')
    fg=$(grep "@define-color popover_fg_color" "$CSS" | awk '{print $3}' | tr -d ';')
    accent_bg=$(grep "@define-color accent_bg_color" "$CSS" | awk '{print $3}' | tr -d ';')
    accent_fg=$(grep "@define-color accent_fg_color" "$CSS" | awk '{print $3}' | tr -d ';')
fi

bg="${bg:-#20201d}"
fg="${fg:-#e5e2de}"
accent_bg="${accent_bg:-#c1cba7}"
accent_fg="${accent_fg:-#2c331a}"

cat << THEME_EOF > "$THEMERC"
# Tự động đồng bộ màu với Noctalia Material You Theme
menu.border.width: 1
menu.border.color: #ffffff1f
menu.items.bg.color: $bg
menu.items.text.color: $fg
menu.items.active.bg.color: $accent_bg
menu.items.active.text.color: $accent_fg
menu.items.padding.x: 12
menu.items.padding.y: 6
menu.separator.width: 1
menu.separator.padding.width: 6
menu.separator.padding.height: 4
menu.separator.color: #ffffff14
menu.title.bg.color: $bg
menu.title.text.color: $fg

osd.bg.color: $bg
osd.border.color: #ffffff1f
osd.border.width: 1
osd.label.text.color: $fg
osd.window-switcher.style-classic.item.active.border.color: $accent_bg
THEME_EOF

labwc --reconfigure 2>/dev/null
