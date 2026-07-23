# dotfiles

One repo, symlinked everywhere. Shared config is tracked; anything
machine-specific lives in untracked `~/.zshrc.local` / `~/.gitconfig.local`.

## New machine

```sh
git clone https://github.com/daveols/dotfiles.git ~/dotfiles
cd ~/dotfiles && chmod +x install.sh
./install.sh              # any machine
./install.sh --yubikey    # machines used with the YubiKey
```

The script is idempotent: it installs Homebrew, core packages
(`gh openssh fzf` + Ghostty, VS Code), oh-my-zsh, and symlinks the
dotfiles (existing files are backed up to `~/dotfiles_old`).

## Per-machine files (untracked)

- `~/.gitconfig.local` — signing config; copy from
  [gitconfig.local.example](gitconfig.local.example) on YubiKey machines,
  omit elsewhere (commits just won't be signed).
- `~/.zshrc.local` — sourced at the end of `.zshrc`; local PATH tweaks,
  aliases, secrets.
- `~/.ssh/config` — `IdentityFile ~/.ssh/id_ed25519_sk` on YubiKey machines
  (needs Homebrew OpenSSH; Apple's build has no FIDO2 support).

## YubiKey notes

- GPG key `8BCD729C7FB0C911` lives on the key (public half:
  `curl https://github.com/daveols.gpg`). Expiry runs to 2028-07-22 —
  extend with `gpg --quick-set-expire <fpr> 2y` (+ subkey fprs) and
  re-upload to GitHub when it lapses.
- The SSH key is a **resident** ed25519-sk credential — recover it on any
  machine with `ssh-keygen -K`.
- OpenPGP User PIN: 3 tries before lockout. FIDO2 PIN: 8 tries.
- No TOTP accounts are stored on the key; website 2FA is FIDO2/WebAuthn.
- **If the key is lost, signing + SSH + 2FA go with it** — keep a backup
  key registered on critical accounts.
