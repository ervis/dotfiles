# dotfiles

Personal development environment and app management with Nix on Ubuntu.
One command to set up Node, packages, shell config, and dev tools declaratively.

## Prerequisites

- Ubuntu (tested on 22.04+)
- curl

## Fresh machine setup

1. Clone the repo:
   ```bash
   git clone https://github.com/ervis/dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```

2. Review the config before running:
   - Update `flake.nix`: change `"ez@thinkpad"` to match your `whoami@hostname`
   - Review `home.nix` packages list and customize as needed

3. Run bootstrap (installs Nix, enables flakes, sets up home-manager):
   ```bash
   ./bootstrap.sh
   ```

Bootstrap does:
1. Installs Determinate Nix (if not present)
2. Enables Nix Flakes in nix.conf
3. Symlinks repo to `~/.dotfiles`
4. Updates flake lockfile
5. Builds and applies home-manager configuration

## Daily use

After bootstrap, edit and apply:

```bash
cd ~/.dotfiles
# Edit home.nix or flake.nix
./rebuild.sh
```

Or manually with your actual username@hostname:
```bash
nix run home-manager/master -- switch --flake ".#$(whoami)@$(hostname)"
```

## Adding packages

Edit `home.nix` in the `home.packages` section:

```nix
home.packages = with pkgs; [
  nodejs
  python3
  rustc
  # Add more here
];
```

Then apply with the `nix run home-manager...` command above.

## Dev shells

For project-specific environments, use `flake.nix`'s `devShells`:

```bash
nix develop  # Enter shell with nodejs and other dev tools
```

Edit `devShells.default.buildInputs` in `flake.nix` to add more tools.
