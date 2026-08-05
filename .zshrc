# oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)
source $ZSH/oh-my-zsh.sh

# homebrew (fallback for shells that skipped ~/.zprofile; harmless otherwise)
[ -d /opt/homebrew/bin ] && export PATH="/opt/homebrew/bin:$PATH"

# flutter / android (mobile dev — dormant unless installed on this machine)
if [ -d "$HOME/development/flutter/bin" ]; then
  export PATH="$HOME/development/flutter/bin:$PATH"
  export PATH="$HOME/.pub-cache/bin:$PATH"
fi
if [ -d "$HOME/Library/Android/sdk" ]; then
  export ANDROID_HOME="$HOME/Library/Android/sdk"
  export PATH="$ANDROID_HOME/platform-tools:$PATH"
fi
[[ -f "$HOME/.dart-cli-completion/zsh-config.zsh" ]] && . "$HOME/.dart-cli-completion/zsh-config.zsh"

# gpg (pinentry needs to know the terminal; harmless where gpg is absent)
export GPG_TTY=$(tty)

# rbenv (only if installed)
if [ -d "$HOME/.rbenv/bin" ]; then
  export PATH="$HOME/.rbenv/bin:$PATH"
fi
if command -v rbenv >/dev/null 2>&1; then
  eval "$(rbenv init - zsh)"
fi

# fzf (keybindings: Ctrl-R history, Ctrl-T files; completion)
if command -v fzf >/dev/null 2>&1 && [ -t 0 ]; then
  source <(fzf --zsh)
fi

# Machine-specific config (untracked) — PATH tweaks, secrets, local aliases.
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
