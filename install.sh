#!/usr/bin/env bash
# Bootstraps this dotfiles setup on a fresh macOS machine.
# Safe to re-run: it backs up anything it would overwrite and only
# creates symlinks, so nothing here can silently clobber real work.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP="$HOME/dotfiles-backup-$(date +%Y%m%d%H%M%S)"

log() { printf '\033[38;5;173m==>\033[0m %s\n' "$1"; }

if ! command -v brew &>/dev/null; then
  log "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

log "Installing packages from Brewfile..."
brew bundle --file="$DOTFILES/Brewfile"

link() {
  local src="$1" dest="$2"
  if [[ -e "$dest" && ! -L "$dest" ]]; then
    mkdir -p "$BACKUP"
    mv "$dest" "$BACKUP/$(basename "$dest")"
    log "Backed up existing $dest -> $BACKUP/"
  fi
  mkdir -p "$(dirname "$dest")"
  ln -sfn "$src" "$dest"
  log "Linked $dest -> $src"
}

link "$DOTFILES/zsh/.zshrc"        "$HOME/.zshrc"
link "$DOTFILES/tmux/.tmux.conf"   "$HOME/.tmux.conf"
link "$DOTFILES/git/.gitconfig"    "$HOME/.gitconfig"
link "$DOTFILES/config/nvim"       "$HOME/.config/nvim"
link "$DOTFILES/config/ghostty"    "$HOME/.config/ghostty"
link "$DOTFILES/config/starship.toml" "$HOME/.config/starship.toml"

if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
  log "Installing tmux plugin manager..."
  git clone --depth 1 https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi
log "Installing tmux plugins..."
"$HOME/.tmux/plugins/tpm/bin/install_plugins" || true

log "Installing Neovim plugins..."
nvim --headless "+Lazy! sync" +qa

log "Installing LSP servers (Mason)..."
nvim --headless "+MasonInstall lua-language-server pyright ruff typescript-language-server bash-language-server json-lsp yaml-language-server marksman" +qa

log "Done. Open a new terminal, or run: exec zsh"
log "See CHEATSHEET.md for the keybindings."
