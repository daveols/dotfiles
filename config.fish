set -x PATH $PATH $HOME/Library/Python/3.8/bin

set -x --universal FLUTTERPATH $HOME/code/flutter
set -x PATH $PATH $FLUTTERPATH/bin

set -x --universal ANDROID_HOME $HOME/Library/Android/sdk
set -x PATH $PATH $ANDROID_HOME/platform-tools

set -x FZF_DEFAULT_COMMAND 'fd --type f'
set -x FZF_DEFAULT_OPTS "
  --height 20%
"

set DOTNET_CLI_TELEMETRY_OPTOUT 1

fish_add_path /opt/homebrew/bin

starship init fish | source
