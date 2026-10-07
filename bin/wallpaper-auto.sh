#!/bin/bash
# ==============================================================================
# Wallhaven Toplist Wallpaper Fetcher (Queue & Prefetch support)
# ==============================================================================

CACHE_DIR="$HOME/.cache/auto-wallpapers"
POOL_DIR="$CACHE_DIR/pool"
LOCK_FILE="${XDG_RUNTIME_DIR:-/tmp}/wallpaper-fetch.lock"

mkdir -p "$CACHE_DIR" "$POOL_DIR"

API_KEY="${WALLHAVEN_API_KEY:-}"
if [ -n "$API_KEY" ]; then
    PURITY="111"
    API_PARAM="&apikey=$API_KEY"
else
    PURITY="110"
    API_PARAM=""
fi

# Category filter: General/Anime/People (100 = General only, exclude anime & people)
CATEGORIES="${WALLHAVEN_CATEGORIES:-100}"

download_single_to() {
    local target_dir="$1"
    local max_attempts=3
    
    for ((attempt = 1; attempt <= max_attempts; attempt++)); do
        local page=$(( RANDOM % 50 + 1 ))
        local api_url="https://wallhaven.cc/api/v1/search?sorting=toplist&topRange=1y&atleast=1600x900&ratios=16x9,16x10,21x9&categories=${CATEGORIES}&purity=${PURITY}&page=${page}${API_PARAM}"
        local response
        response=$(curl -s --max-time 8 "$api_url")
        
        local all_paths
        all_paths=$(echo "$response" | jq -r '.data[].path' 2>/dev/null)
        [ -z "$all_paths" ] && continue
        
        local candidates=()
        while IFS= read -r url; do
            [ -z "$url" ] || [ "$url" = "null" ] && continue
            local name="${url##*/}"
            if [ ! -f "$CACHE_DIR/$name" ] && [ ! -f "$POOL_DIR/$name" ]; then
                candidates+=("$url")
            fi
        done <<< "$all_paths"
        
        if [ ${#candidates[@]} -gt 0 ]; then
            local chosen_idx=$(( RANDOM % ${#candidates[@]} ))
            local img_url="${candidates[$chosen_idx]}"
            local img_name="${img_url##*/}"
            local dest="$target_dir/$img_name"
            local tmp_dest="${dest}.tmp.$$"
            
            if curl -s --max-time 25 -o "$tmp_dest" "$img_url" && [ -s "$tmp_dest" ]; then
                mv "$tmp_dest" "$dest"
                echo "$dest"
                return 0
            else
                rm -f "$tmp_dest"
            fi
        fi
        sleep 0.5
    done
    return 1
}

cleanup_cache() {
    local max_files=50
    local history_file="$CACHE_DIR/history.log"
    local pos_file="$CACHE_DIR/history.pos"
    
    shopt -s nullglob
    local all_imgs=("$CACHE_DIR"/*.jpg "$CACHE_DIR"/*.png)
    shopt -u nullglob
    local count=${#all_imgs[@]}
    
    if [ "$count" -le "$max_files" ]; then
        return 0
    fi
    
    # Identify currently displayed wallpaper (protect from deletion)
    local current_img
    current_img=$(noctalia msg wallpaper-get 2>/dev/null)
    
    # Get oldest images by modification time for pruning
    local to_remove=$(( count - max_files ))
    local removed=0
    
    while IFS= read -r old_file; do
        [ "$removed" -ge "$to_remove" ] && break
        [ "$old_file" = "$current_img" ] && continue
        rm -f "$old_file"
        # Remove corresponding entry from history.log
        if [ -f "$history_file" ]; then
            grep -vxF "$old_file" "$history_file" > "${history_file}.tmp" && \
                mv "${history_file}.tmp" "$history_file"
        fi
        removed=$(( removed + 1 ))
    done < <(ls -t "$CACHE_DIR"/*.jpg "$CACHE_DIR"/*.png 2>/dev/null | tail -n "$to_remove")
    
    # Update history.pos for current image position
    if [ -f "$history_file" ] && [ -n "$current_img" ]; then
        local new_pos
        new_pos=$(grep -nxF "$current_img" "$history_file" | cut -d: -f1 | head -n 1)
        if [ -n "$new_pos" ]; then
            echo "$new_pos" > "$pos_file"
        fi
    fi
}

refill_pool() {
    (
        flock -n 200 || exit 0
        local target_count=5
        
        while true; do
            shopt -s nullglob
            local pool_files=("$POOL_DIR"/*.jpg "$POOL_DIR"/*.png)
            shopt -u nullglob
            local count=${#pool_files[@]}
            if [ "$count" -ge "$target_count" ]; then
                break
            fi
            
            if ! download_single_to "$POOL_DIR" >/dev/null 2>&1; then
                sleep 2
                break
            fi
            sleep 0.5
        done
        
        cleanup_cache
    ) 200>"$LOCK_FILE"
}

# 1. Download a single wallpaper directly into CACHE_DIR
if [ "$1" = "--download-one" ]; then
    download_single_to "$CACHE_DIR"
    exit 0
fi

# 2. Refill the prefetch queue (POOL)
if [ "$1" = "--refill" ]; then
    refill_pool
    exit 0
fi

# 3. Default execution on login or via systemd timer
for i in {1..10}; do
    if noctalia msg status >/dev/null 2>&1; then
        break
    fi
    sleep 1
done

# Cycle to next wallpaper
wallpaper-cycle.sh next

# Clean cache if exceeding file limit
cleanup_cache

exit 0
