#!/usr/bin/env bash
# Quick rebuild script for home-manager
set -e

HOSTNAME=$(hostname)
USERNAME=$(whoami)
FLAKE_REF="${USERNAME}@${HOSTNAME}"

echo "Rebuilding home configuration (${FLAKE_REF})..."
cd ~/.dotfiles
nix run home-manager/master -- switch --flake ".#${FLAKE_REF}"
echo "Done."
