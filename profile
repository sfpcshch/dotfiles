# ~/.profile - User environment for POSIX login shells (loaded by display manager / ly)

# User local bin
export PATH="$HOME/.local/bin:$PATH"

# Development Environment (Java & Android SDK)
export JAVA_HOME="$HOME/.local/share/java/jdk-17.0.20.1+1"
export ANDROID_HOME="$HOME/Android/Sdk"
export ANDROID_SDK_ROOT="$HOME/Android/Sdk"

[ -d "$JAVA_HOME/bin" ] && export PATH="$JAVA_HOME/bin:$PATH"
[ -d "$ANDROID_HOME/platform-tools" ] && export PATH="$ANDROID_HOME/platform-tools:$PATH"
