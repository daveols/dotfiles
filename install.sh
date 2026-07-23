#!/bin/bash
# Bootstrap a new Mac from this dotfiles repo. Idempotent — safe to re-run.
#
#   ./install.sh             # base setup (any machine)
#   ./install.sh --yubikey   # base + YubiKey tooling (machines used with the key)
#
set -u

dir=~/dotfiles
olddir=~/dotfiles_old
files=".vimrc .zshrc .gitconfig"

with_yubikey=false
[ "${1:-}" = "--yubikey" ] && with_yubikey=true

# --- 1. Homebrew ------------------------------------------------------------
if ! command -v brew >/dev/null 2>&1 && [ ! -x /opt/homebrew/bin/brew ] && [ ! -x /usr/local/bin/brew ]; then
  echo "==> Installing Homebrew (you'll be asked for your password)"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
# Put brew on PATH for the rest of this script (Apple Silicon or Intel).
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# --- 2. Core packages (any machine) ------------------------------------------
echo "==> Installing core packages"
brew install gh openssh fzf
brew install --cask ghostty visual-studio-code

# --- 3. oh-my-zsh -------------------------------------------------------------
if [ ! -d ~/.oh-my-zsh ]; then
  echo "==> Installing oh-my-zsh"
  # Guards: don't switch shell, don't launch zsh, don't clobber our .zshrc symlink.
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# --- 4. Symlink dotfiles -------------------------------------------------------
echo "==> Linking dotfiles (existing files back up to $olddir)"
mkdir -p $olddir
cd $dir
for file in $files; do
  # Skip if already correctly linked; back up anything else that's in the way.
  if [ "$(readlink ~/$file 2>/dev/null)" = "$dir/$file" ]; then
    continue
  fi
  [ -e ~/$file ] && mv ~/$file $olddir/
  ln -sfn $dir/$file ~/$file
done

# VS Code settings (create the dir — it only appears after first launch otherwise).
vscode_user=~/Library/Application\ Support/Code/User
mkdir -p "$vscode_user"
if [ "$(readlink "$vscode_user/settings.json" 2>/dev/null)" != "$dir/settings.json" ]; then
  [ -e "$vscode_user/settings.json" ] && mv "$vscode_user/settings.json" $olddir/
  ln -sfn $dir/settings.json "$vscode_user/settings.json"
fi

# --- 5. YubiKey machines only (--yubikey) --------------------------------------
if $with_yubikey; then
  echo "==> Installing YubiKey tooling"
  brew install ykman gnupg pinentry-mac
  brew install --cask yubico-authenticator

  echo "==> Configuring gpg-agent to use pinentry-mac"
  mkdir -p ~/.gnupg && chmod 700 ~/.gnupg
  echo "pinentry-program $(brew --prefix)/bin/pinentry-mac" > ~/.gnupg/gpg-agent.conf
  gpgconf --kill gpg-agent 2>/dev/null

  cat <<'STEPS'

  YubiKey manual steps (with the key inserted):
    1. Commit signing:
         curl -fsSL https://github.com/daveols.gpg | gpg --import
         gpg --card-status
         cp ~/dotfiles/gitconfig.local.example ~/.gitconfig.local
    2. SSH (the key is resident on the YubiKey):
         cd ~/.ssh && ssh-keygen -K       # prompts FIDO2 PIN + touch
         mv id_ed25519_sk_rk id_ed25519_sk
         mv id_ed25519_sk_rk.pub id_ed25519_sk.pub
         printf 'Host *\n  IdentityFile ~/.ssh/id_ed25519_sk\n' >> ~/.ssh/config
    3. GitHub auth: gh auth login
STEPS
fi

# --- Done -----------------------------------------------------------------------
echo
echo "Done. Restart your shell (or open a new tab) to pick everything up."
echo "Machine-specific extras go in ~/.zshrc.local and ~/.gitconfig.local (untracked)."
