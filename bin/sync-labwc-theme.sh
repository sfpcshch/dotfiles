#!/bin/bash
# ==============================================================================
# Sync Labwc Menu & OSD colors with Noctalia palette (Material You)
# Optimized: 100% bash built-in (0 external subshells), write only on color changes
# ==============================================================================

CSS="$HOME/.config/gtk-3.0/noctalia.css"
THEMERC="$HOME/.config/labwc/themerc-override"

bg="" fg="" accent_bg="" accent_fg=""
if [ -f "$CSS" ]; then
    while read -r a b c rest; do
        case "$b" in
            popover_bg_color) bg="${c%;}" ;;
            popover_fg_color) fg="${c%;}" ;;
            accent_bg_color)  accent_bg="${c%;}" ;;
            accent_fg_color)  accent_fg="${c%;}" ;;
        esac
        [ -n "$bg" ] && [ -n "$fg" ] && [ -n "$accent_bg" ] && [ -n "$accent_fg" ] && break
    done < "$CSS"
fi

bg="${bg:-#20201d}"
fg="${fg:-#e5e2de}"
accent_bg="${accent_bg:-#c1cba7}"
accent_fg="${accent_fg:-#2c331a}"

# Only write to disk when menu colors change
need_write=true
if [ -f "$THEMERC" ]; then
    cur=$(<"$THEMERC")
    if [[ "$cur" == *"menu.items.bg.color: $bg"* ]] && \
       [[ "$cur" == *"menu.items.active.bg.color: $accent_bg"* ]]; then
        need_write=false
    fi
fi

if [ "$need_write" = true ]; then
cat << THEME_EOF > "$THEMERC"
# Automatically synchronized with Noctalia Material You Theme

# Windows 10 style rectangular titlebar buttons (44x20 flush dimensions)
window.button.width: 22
window.button.height: 20
window.button.spacing: 6
window.titlebar.padding.width: 0

# Left-align window title label next to app icon
window.label.text.justify: left

# Alt+Tab window switcher OSD (neutral dark tone)
osd.bg.color: #1a1a1e
osd.border.color: #ffffff20
osd.border.width: 1
osd.label.text.color: #e5e5e5
osd.window-switcher.style-thumbnail.item.active.border.color: #ffffff40
osd.window-switcher.style-thumbnail.item.active.bg.color: #ffffff15
osd.window-switcher.preview.border.color: #ffffff30

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
THEME_EOF
fi

labwc --reconfigure 2>/dev/null
