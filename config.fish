set -x --universal FLUTTERPATH $HOME/development/flutter
set -x PATH $PATH $FLUTTERPATH/bin

set -x --universal ANDROID_HOME $HOME/Library/Android/sdk
set -x PATH $PATH $ANDROID_HOME/platform-tools

set -x FZF_DEFAULT_COMMAND 'fd --type f'
set -x FZF_DEFAULT_OPTS "
  --height 20%
"

starship init fish | source
