#!/usr/bin/env bash
# Quick rebuild script for home-manager
set -e

USERNAME="${USERNAME:-$(whoami)}"
HOSTNAME="${HOSTNAME:-$(hostname)}"
FLAKE_REF="${USERNAME}@${HOSTNAME}"

echo "Rebuilding home configuration (${FLAKE_REF})..."
cd ~/.dotfiles
nix run home-manager/master -- switch -b backup --flake ".#${FLAKE_REF}"
echo "Done."
