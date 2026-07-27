#!/usr/bin/env bash
set -e

echo "=== Dotfiles Bootstrap (Ubuntu with Nix) ==="

# 1. Install Nix if not already installed
if ! command -v nix &> /dev/null; then
  echo "Installing Determinate Nix..."
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
  # Source nix-daemon setup
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
else
  echo "Nix already installed: $(nix --version)"
fi

# 2. Enable Nix Flakes
echo "Enabling Nix Flakes..."
mkdir -p ~/.config/nix
if ! grep -q "experimental-features" ~/.config/nix/nix.conf 2>/dev/null; then
  echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
fi

# 3. Symlink repo to ~/.dotfiles
echo "Symlinking repo to ~/.dotfiles..."
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ ! -L ~/.dotfiles ]; then
  if [ -e ~/.dotfiles ]; then
    echo "Warning: ~/.dotfiles exists and is not a symlink. Backing up to ~/.dotfiles.bak"
    mv ~/.dotfiles ~/.dotfiles.bak
  fi
  ln -s "$DOTFILES_DIR" ~/.dotfiles
fi

# 4. Update flake lockfile
echo "Updating flake lockfile..."
cd ~/.dotfiles
nix flake update

# 5. Build and switch to home-manager config
echo "Building home-manager configuration..."
nix run home-manager/master -- switch --flake .#$(whoami)@$(hostname)

echo "=== Bootstrap complete ==="
echo "To make changes and rebuild:"
echo "  cd ~/.dotfiles"
echo "  edit home.nix or add packages to flake.nix"
echo "  nix run home-manager/master -- switch --flake .#$(whoami)@$(hostname)"
