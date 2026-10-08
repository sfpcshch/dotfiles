#!/bin/bash
# ==============================================================================
# Instant Wallpaper Cycling (Deterministic Linear Queue / Playlist)
# ==============================================================================

CACHE_DIR="$HOME/.cache/auto-wallpapers"
POOL_DIR="$CACHE_DIR/pool"
HISTORY_FILE="$CACHE_DIR/history.log"
POS_FILE="$CACHE_DIR/history.pos"
CYCLE_LOCK="${XDG_RUNTIME_DIR:-/tmp}/wallpaper-cycle.lock"

mkdir -p "$CACHE_DIR" "$POOL_DIR"

# Lock file descriptor to prevent race conditions on rapid hotkey presses
exec 201>"$CYCLE_LOCK"
flock 201 || exit 1

ACTION="${1:-next}"

# 1. Initialize history.log if missing
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

# 2. Read history entry count and current cursor position
TOTAL=$(wc -l < "$HISTORY_FILE" 2>/dev/null || echo 0)
read -r POS < "$POS_FILE" 2>/dev/null || POS=""

if ! [[ "$POS" =~ ^[0-9]+$ ]] || [ "$POS" -lt 1 ]; then
    POS=$TOTAL
fi
if [ "$POS" -gt "$TOTAL" ] && [ "$TOTAL" -gt 0 ]; then
    POS=$TOTAL
fi

TARGET_WALLPAPER=""
NEED_REFILL=false

# 3. Handle PREV action (Step backwards in history)
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

# 4. Handle NEXT action
elif [ "$ACTION" = "next" ]; then
    # Case 4A: Browsing back in history -> Advance forward towards newest
    if [ "$POS" -lt "$TOTAL" ]; then
        NEW_POS=$(( POS + 1 ))
        TARGET_IMG=$(sed -n "${NEW_POS}p" "$HISTORY_FILE")
        if [ -f "$TARGET_IMG" ]; then
            echo "$NEW_POS" > "$POS_FILE"
            TARGET_WALLPAPER="$TARGET_IMG"
        fi
    else
        # Case 4B: At newest wallpaper -> Fetch NEW image from prefetch pool
        shopt -s nullglob
        pool_files=("$POOL_DIR"/*.jpg "$POOL_DIR"/*.png)
        shopt -u nullglob

        if [ ${#pool_files[@]} -gt 0 ]; then
            new_img="${pool_files[0]}"
            img_name="${new_img##*/}"
            dest="$CACHE_DIR/$img_name"
            mv "$new_img" "$dest"
            
            echo "$dest" >> "$HISTORY_FILE"
            NEW_POS=$(( TOTAL + 1 ))
            echo "$NEW_POS" > "$POS_FILE"
            TARGET_WALLPAPER="$dest"
            NEED_REFILL=true
        else
            # Pool temporarily empty -> Download single image synchronously
            dest=$(~/.local/bin/wallpaper-auto.sh --download-one 201>&-)
            if [ -n "$dest" ] && [ -f "$dest" ]; then
                echo "$dest" >> "$HISTORY_FILE"
                NEW_POS=$(( TOTAL + 1 ))
                echo "$NEW_POS" > "$POS_FILE"
                TARGET_WALLPAPER="$dest"
                NEED_REFILL=true
            else
                fallback_img=$(find "$CACHE_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.png" \) 2>/dev/null | shuf -n 1)
                if [ -n "$fallback_img" ] && [ -f "$fallback_img" ]; then
                    TARGET_WALLPAPER="$fallback_img"
                fi
            fi
        fi
    fi
fi

# Unlock and close file descriptor before setting wallpaper and triggering background tasks
flock -u 201 2>/dev/null
exec 201>&-

# Apply wallpaper (Noctalia natively generates templates and triggers labwc reconfigure with 0 overhead)
if [ -n "$TARGET_WALLPAPER" ]; then
    noctalia msg wallpaper-set "$TARGET_WALLPAPER" >/dev/null 2>&1
fi

# Automatically refill pool in background
if [ "$NEED_REFILL" = true ]; then
    ~/.local/bin/wallpaper-auto.sh --refill >/dev/null 2>&1 &
fi

exit 0
