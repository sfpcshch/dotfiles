source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end

# Development Environment (Java & Android)
set -gx JAVA_HOME /home/tung/.local/share/java/jdk-17.0.20.1+1
set -gx ANDROID_HOME /home/tung/Android/Sdk
set -gx ANDROID_SDK_ROOT /home/tung/Android/Sdk
fish_add_path -a $JAVA_HOME/bin
fish_add_path -a $ANDROID_HOME/platform-tools

# Qt Theme & Wayland Integration
set -gx QT_QPA_PLATFORMTHEME qt6ct
set -gx QT_QPA_PLATFORM "wayland;xcb"
set -gx XMODIFIERS "@im=fcitx"
set -gx QT_IM_MODULE fcitx
