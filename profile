# ~/.profile - User environment for POSIX login shells (loaded by display manager / ly)

_prepend_path() {
    [ -d "$1" ] || return 0
    case ":$PATH:" in
        *":$1:"*) ;;
        *) export PATH="$1:$PATH" ;;
    esac
}

# Development Environment (Java & Android SDK)
export JAVA_HOME="$HOME/.local/share/java/jdk-17.0.20.1+1"
export ANDROID_HOME="$HOME/Android/Sdk"
export ANDROID_SDK_ROOT="$HOME/Android/Sdk"

_prepend_path "$ANDROID_HOME/platform-tools"
_prepend_path "$JAVA_HOME/bin"
_prepend_path "$HOME/.local/bin"
unset -f _prepend_path

# Qt Theme & Wayland Integration (Dolphin, Qt apps)
export QT_QPA_PLATFORMTHEME="qt6ct"
export QT_QPA_PLATFORM="wayland;xcb"

# Input Method (Fcitx5)
export XMODIFIERS="@im=fcitx"
export QT_IM_MODULE="fcitx"
