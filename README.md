# dotfiles

Personal development environment and app management with Nix.

## Setup

1. Install Nix (if not already installed):
   ```bash
   curl -L https://nixos.org/nix/install | sh
   ```

2. Enable Nix Flakes (add to `~/.config/nix/nix.conf`):
   ```
   experimental-features = nix-command flakes
   ```

3. Enter the dev shell:
   ```bash
   nix flake update  # Update lockfile
   nix develop       # Enter shell with all tools
   ```

## Adding apps

Edit `flake.nix` and add packages to `buildInputs`. Example:
```nix
buildInputs = with pkgs; [
  nodejs
  python3
  rustc
];
```

Then run `nix flake update` to update the lockfile.
