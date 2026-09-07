#!/bin/bash
# ==============================================================================
# Bộ tải hình nền Wallhaven Toplist (Hỗ trợ hàng đợi & tải gối đầu)
# ==============================================================================

CACHE_DIR="$HOME/.cache/auto-wallpapers"
POOL_DIR="$CACHE_DIR/pool"
LOCK_FILE="/tmp/wallpaper-fetch.lock"

mkdir -p "$CACHE_DIR" "$POOL_DIR"

API_KEY=""
if [ -n "$API_KEY" ]; then
    PURITY="111"
    API_PARAM="&apikey=$API_KEY"
else
    PURITY="110"
    API_PARAM=""
fi

download_single_to() {
    local target_dir="$1"
    local max_attempts=5
    
    for attempt in $(seq 1 $max_attempts); do
        local page=$(( RANDOM % 5 + 1 ))
        local api_url="https://wallhaven.cc/api/v1/search?sorting=toplist&topRange=1y&atleast=1600x900&ratios=16x9,16x10,21x9&purity=${PURITY}&page=${page}${API_PARAM}"
        local response
        response=$(curl -s --max-time 8 "$api_url")
        
        local img_url
        img_url=$(echo "$response" | jq -r '.data[].path' 2>/dev/null | shuf -n 1)
        
        if [ -n "$img_url" ] && [ "$img_url" != "null" ]; then
            local img_name
            img_name=$(basename "$img_url")
            local dest="$target_dir/$img_name"
            
            # Chỉ tải nếu chưa có trong cache và chưa có trong pool
            if [ ! -f "$CACHE_DIR/$img_name" ] && [ ! -f "$POOL_DIR/$img_name" ]; then
                local tmp_dest="${dest}.tmp.$$"
                if curl -s --max-time 25 -o "$tmp_dest" "$img_url" && [ -s "$tmp_dest" ]; then
                    mv "$tmp_dest" "$dest"
                    echo "$dest"
                    return 0
                else
                    rm -f "$tmp_dest"
                fi
            fi
        fi
        sleep 0.5
    done
    return 1
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
    ) 200>"$LOCK_FILE"
}

# 1. Tải 1 ảnh duy nhất (đồng bộ vào CACHE_DIR)
if [ "$1" = "--download-one" ]; then
    download_single_to "$CACHE_DIR"
    exit 0
fi

# 2. Nạp bù hàng đợi POOL
if [ "$1" = "--refill" ]; then
    refill_pool
    exit 0
fi

# 3. Tự động dọn dẹp cache khi quá 50 ảnh
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
    
    # Xác định ảnh đang hiển thị hiện tại (bảo vệ, không xóa)
    local current_img
    current_img=$(noctalia msg wallpaper-get 2>/dev/null)
    
    # Lấy danh sách ảnh cũ nhất (theo thời gian modify) để xóa
    local to_remove=$(( count - max_files ))
    local removed=0
    
    while IFS= read -r old_file; do
        [ "$removed" -ge "$to_remove" ] && break
        [ "$old_file" = "$current_img" ] && continue
        rm -f "$old_file"
        # Xóa entry tương ứng khỏi history.log
        if [ -f "$history_file" ]; then
            grep -vxF "$old_file" "$history_file" > "${history_file}.tmp" && \
                mv "${history_file}.tmp" "$history_file"
        fi
        removed=$(( removed + 1 ))
    done < <(ls -t "$CACHE_DIR"/*.jpg "$CACHE_DIR"/*.png 2>/dev/null | tail -n "$to_remove")
    
    # Cập nhật lại history.pos cho đúng vị trí ảnh hiện tại
    if [ -f "$history_file" ] && [ -n "$current_img" ]; then
        local new_pos
        new_pos=$(grep -nxF "$current_img" "$history_file" | cut -d: -f1 | head -n 1)
        if [ -n "$new_pos" ]; then
            echo "$new_pos" > "$pos_file"
        fi
    fi
}

# 4. Chạy mặc định khi login hoặc qua timer:
for i in {1..10}; do
    if noctalia msg status >/dev/null 2>&1; then
        break
    fi
    sleep 1
done

# Gọi cycle next
wallpaper-cycle.sh next


# Dọn cache nếu quá 50 ảnh
cleanup_cache

exit 0
