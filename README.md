# dotfiles

One repo, symlinked everywhere. Shared config is tracked; anything
machine-specific lives in untracked `~/.zshrc.local` / `~/.gitconfig.local`.

## New machine

```sh
git clone https://github.com/daveols/dotfiles.git ~/dotfiles
cd ~/dotfiles && chmod +x install.sh
./install.sh work         # work machine: core + YubiKey tooling
./install.sh personal     # personal machine: core + personal apps, no YubiKey
```

The script is idempotent. Both profiles get: Homebrew, `gh` + `fzf`,
Ghostty, VS Code, oh-my-zsh, and the dotfile symlinks (existing files are
backed up to `~/dotfiles_old`).

- **work** adds the YubiKey stack (`openssh ykman gnupg pinentry-mac`,
  Yubico Authenticator, gpg-agent config) and prints the on-card key
  recovery steps. Work-managed apps (Office, Teams, VPN…) are IT's
  problem, not dotfiles'.
- **personal** adds Brave, Rectangle, Caffeine, Claude, ChatGPT. No
  YubiKey: skip `~/.gitconfig.local` and commits are simply unsigned.
  JS runtimes (node/pnpm/bun/…) are deliberately per-project — install
  what each machine needs, when it needs it.

## Per-machine files (untracked)

- `~/.gitconfig.local` — signing config; copy from
  [gitconfig.local.example](gitconfig.local.example) on YubiKey machines,
  omit elsewhere (commits just won't be signed).
- `~/.zshrc.local` — sourced at the end of `.zshrc`; local PATH tweaks,
  aliases, secrets.
- `~/.ssh/config` — `IdentityFile ~/.ssh/id_ed25519_sk` on YubiKey machines
  (needs Homebrew OpenSSH; Apple's build has no FIDO2 support).

## YubiKey notes (work machines)

- The commit-signing GPG key lives on the YubiKey; only the public half
  is ever imported (`curl https://github.com/daveols.gpg`). When it nears
  expiry: `gpg --quick-set-expire <fpr> 2y` (primary + subkey fprs), then
  re-upload the public key to GitHub.
- The SSH key is a **resident** ed25519-sk credential — recover it on any
  machine with `ssh-keygen -K`.
