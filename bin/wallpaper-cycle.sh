#!/bin/bash
# ==============================================================================
# Chuyển đổi hình nền tức thì (Deterministic Linear Queue / Playlist)
# ==============================================================================

CACHE_DIR="$HOME/.cache/auto-wallpapers"
POOL_DIR="$CACHE_DIR/pool"
HISTORY_FILE="$CACHE_DIR/history.log"
POS_FILE="$CACHE_DIR/history.pos"
CYCLE_LOCK="/tmp/wallpaper-cycle.lock"

mkdir -p "$CACHE_DIR" "$POOL_DIR"

# Khóa xử lý để đảm bảo khi click liên tục không bị race condition
exec 201>"$CYCLE_LOCK"
flock 201 || exit 1

ACTION="${1:-next}"

# 1. Khởi tạo history.log nếu chưa có
if [ ! -s "$HISTORY_FILE" ]; then
    find "$CACHE_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.png" \) -printf "%T@ %p\n" | \
        sort -n | cut -d' ' -f2- > "$HISTORY_FILE"
    
    TOTAL=$(wc -l < "$HISTORY_FILE")
    if [ "$TOTAL" -gt 0 ]; then
        CURRENT_IMG=$(noctalia msg wallpaper-get 2>/dev/null)
        CUR_LINE=""
        if [ -n "$CURRENT_IMG" ]; then
            CUR_LINE=$(grep -nxF "$CURRENT_IMG" "$HISTORY_FILE" | cut -d: -f1 | head -n 1)
        fi
        if [ -n "$CUR_LINE" ]; then
            echo "$CUR_LINE" > "$POS_FILE"
        else
            echo "$TOTAL" > "$POS_FILE"
        fi
    else
        echo "0" > "$POS_FILE"
    fi
fi

# 2. Đọc tổng số ảnh trong lịch sử và vị trí hiện tại
TOTAL=$(wc -l < "$HISTORY_FILE" 2>/dev/null || echo 0)
POS=$(cat "$POS_FILE" 2>/dev/null)

if ! [[ "$POS" =~ ^[0-9]+$ ]] || [ "$POS" -lt 1 ]; then
    POS=$TOTAL
fi
if [ "$POS" -gt "$TOTAL" ] && [ "$TOTAL" -gt 0 ]; then
    POS=$TOTAL
fi

TARGET_WALLPAPER=""
NEED_REFILL=false

# 3. Xử lý PREV (Lùi về ảnh cũ hơn)
if [ "$ACTION" = "prev" ]; then
    if [ "$POS" -gt 1 ]; then
        NEW_POS=$(( POS - 1 ))
        TARGET_IMG=$(sed -n "${NEW_POS}p" "$HISTORY_FILE")
        if [ -f "$TARGET_IMG" ]; then
            echo "$NEW_POS" > "$POS_FILE"
            TARGET_WALLPAPER="$TARGET_IMG"
        fi
    else
        notify-send "Wallpaper" "Already at the oldest wallpaper." >/dev/null 2>&1 &
    fi

# 4. Xử lý NEXT
elif [ "$ACTION" = "next" ]; then
    # Trường hợp 4A: Đang xem lại ảnh cũ -> Tiến dần về ảnh mới hơn trong lịch sử
    if [ "$POS" -lt "$TOTAL" ]; then
        NEW_POS=$(( POS + 1 ))
        TARGET_IMG=$(sed -n "${NEW_POS}p" "$HISTORY_FILE")
        if [ -f "$TARGET_IMG" ]; then
            echo "$NEW_POS" > "$POS_FILE"
            TARGET_WALLPAPER="$TARGET_IMG"
        fi
    else
        # Trường hợp 4B: Đang ở ảnh mới nhất -> Lấy ảnh MỚI
        shopt -s nullglob
        pool_files=("$POOL_DIR"/*.jpg "$POOL_DIR"/*.png)
        shopt -u nullglob

        if [ ${#pool_files[@]} -gt 0 ]; then
            new_img="${pool_files[0]}"
            img_name=$(basename "$new_img")
            dest="$CACHE_DIR/$img_name"
            mv "$new_img" "$dest"
            
            echo "$dest" >> "$HISTORY_FILE"
            NEW_POS=$(( TOTAL + 1 ))
            echo "$NEW_POS" > "$POS_FILE"
            TARGET_WALLPAPER="$dest"
            NEED_REFILL=true
        else
            # Pool tạm thời rỗng (do click liên tục vượt quá 5 ảnh dự trữ)
            # Tải đồng bộ 1 ảnh ngay lập tức
            dest=$(~/.config/labwc/wallpaper-auto.sh --download-one 201>&-)
            if [ -n "$dest" ] && [ -f "$dest" ]; then
                echo "$dest" >> "$HISTORY_FILE"
                NEW_POS=$(( TOTAL + 1 ))
                echo "$NEW_POS" > "$POS_FILE"
                TARGET_WALLPAPER="$dest"
                NEED_REFILL=true
            else
                notify-send "Wallpaper" "No internet connection or failed to download image." >/dev/null 2>&1 &
            fi
        fi
    fi
fi

# Mở khóa và đóng file descriptor trước khi set hình nền và chạy tác vụ nền
flock -u 201 2>/dev/null
exec 201>&-

# Áp dụng hình nền
if [ -n "$TARGET_WALLPAPER" ]; then
    noctalia msg wallpaper-set "$TARGET_WALLPAPER" >/dev/null 2>&1
fi

# Tự động nạp bù ảnh vào pool nếu vừa tiêu thụ
if [ "$NEED_REFILL" = true ]; then
    ~/.config/labwc/wallpaper-auto.sh --refill >/dev/null 2>&1 &
fi

exit 0
