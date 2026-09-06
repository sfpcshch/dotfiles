#!/bin/sh
# Thu nhỏ tất cả cửa sổ để hiện Desktop (hoặc hoàn tác)
# Gửi tổ hợp phím Win+D vào Labwc
if command -v wtype >/dev/null 2>&1; then
    wtype -M logo -k d -m logo
fi
