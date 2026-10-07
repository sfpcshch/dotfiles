source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end

# Development Environment (Java & Android)
set -gx JAVA_HOME $HOME/.local/share/java/jdk-17.0.20.1+1
set -gx ANDROID_HOME $HOME/Android/Sdk
set -gx ANDROID_SDK_ROOT $HOME/Android/Sdk
test -d "$JAVA_HOME/bin" && fish_add_path -a $JAVA_HOME/bin
test -d "$ANDROID_HOME/platform-tools" && fish_add_path -a $ANDROID_HOME/platform-tools

# Qt Theme & Wayland Integration
set -gx QT_QPA_PLATFORMTHEME qt6ct
set -gx QT_QPA_PLATFORM "wayland;xcb"
set -gx XMODIFIERS "@im=fcitx"
set -gx QT_IM_MODULE fcitx
starship init fish | source

# --- Modern Unix Tools (Zero Overhead) ---
# System Monitor: btop thay thế top/htop
if type -q btop
    alias top="btop"
    alias htop="btop"
end

# File Viewer: bat thay thế cat
if type -q bat
    alias cat="bat --style=plain"
    alias bcat="bat"
end

# Default Editor: micro thay thế nano
if type -q micro
    set -gx EDITOR micro
    set -gx VISUAL micro
end

# Fuzzy Finder: fzf tích hợp phím tắt (Ctrl+R tìm lệnh, Ctrl+T tìm file)
if type -q fzf
    fzf --fish | source
end
