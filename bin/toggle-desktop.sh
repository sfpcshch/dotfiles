#!/bin/sh
# Minimize all windows to show Desktop (or undo)
# Sends Win+D keystroke via wtype into Labwc
if command -v wtype >/dev/null 2>&1; then
    wtype -M logo -k d -m logo
fi
