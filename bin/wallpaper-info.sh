#!/bin/bash
# ==============================================================================
# Mở trang nguồn của hình nền hiện tại trên trình duyệt (0% tài nguyên)
# ==============================================================================

CURRENT_IMG=$(noctalia msg wallpaper-get 2>/dev/null)
BASENAME=$(basename "$CURRENT_IMG" 2>/dev/null)

if [[ "$BASENAME" =~ wallhaven-([a-zA-Z0-9]+) ]]; then
    ID="${BASH_REMATCH[1]}"
    URL="https://wallhaven.cc/w/$ID"
    xdg-open "$URL" >/dev/null 2>&1 &
else
    notify-send "Wallpaper Source" "No online source found for this wallpaper." >/dev/null 2>&1
fi

exit 0
