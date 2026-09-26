# Local dictation (whisper.cpp + GNOME shortcut)

Offline speech-to-text for any focused window, including the Claude Code prompt.
Audio never leaves the machine: it is recorded to a temp file, transcribed locally by whisper.cpp, and deleted.
Press Super+/ to start recording, press it again to stop, and the text is typed into the focused window.

This file is written for an agent setting up a machine.
Follow the steps in order and verify each one before moving on.

## Pieces

- `home/.local/bin/dictate-toggle` - the script, linked to `~/.local/bin/dictate-toggle` by `home.nix`.
- whisper.cpp built in `~/.local/src/whisper.cpp` with a model in its `models/` folder (not committed, too large and machine-specific).
- `ydotool` and its daemon, used to type text on Wayland.
- A GNOME custom shortcut, Super+/, that runs the script (set with `gsettings`, not stored in this repo).

## Requirements

Ubuntu with GNOME on Wayland (`echo $XDG_SESSION_TYPE` prints `wayland`).
Packages: `git cmake gcc g++ make sox ydotool wl-clipboard libnotify-bin`.
The user must be in the `input` group (`id -nG` lists `input`) so `ydotool` can use `/dev/uinput`.
If `input` is missing, run `sudo usermod -aG input "$USER"` and tell the user to log out and back in.

## 1. Link the script

Apply the home-manager config (`./rebuild.sh` from `~/.dotfiles`).
It links `~/.local/bin/dictate-toggle` to `home/.local/bin/dictate-toggle`.
If a regular file already exists at that path, home-manager refuses to overwrite it.
Move it aside first: `mv ~/.local/bin/dictate-toggle ~/.local/bin/dictate-toggle.bak`.

Check: `test -x ~/.local/bin/dictate-toggle && echo ok`.

## 2. Build whisper.cpp

```bash
git clone --depth 1 https://github.com/ggml-org/whisper.cpp ~/.local/src/whisper.cpp
cmake -S ~/.local/src/whisper.cpp -B ~/.local/src/whisper.cpp/build -DCMAKE_BUILD_TYPE=Release
cmake --build ~/.local/src/whisper.cpp/build -j"$(nproc)" --config Release
sh ~/.local/src/whisper.cpp/models/download-ggml-model.sh base.en
```

The script expects `build/bin/whisper-cli` and `models/ggml-base.en.bin` under `~/.local/src/whisper.cpp`.
Check: `~/.local/src/whisper.cpp/build/bin/whisper-cli -m ~/.local/src/whisper.cpp/models/ggml-base.en.bin -f ~/.local/src/whisper.cpp/samples/jfk.wav -nt` prints a transcript.

A bigger model is more accurate and slower.
Download another with `sh ~/.local/src/whisper.cpp/models/download-ggml-model.sh small.en`, then set `DICTATE_MODEL` to its path.

## 3. Make ydotool work

The script types through the ydotool daemon socket at `$XDG_RUNTIME_DIR/.ydotool_socket`.
Check the daemon runs: `pgrep -a ydotoold`.
If it does not, start it as a user service or with `ydotoold &`, and confirm the socket exists.

## 4. Add the GNOME shortcut (Super+/)

```bash
B=/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings
gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings
```

Pick an unused slot name such as `custom1`, and keep every existing entry in the list.
Then, replacing `customN` with that slot and the list with the existing entries plus the new one:

```bash
K=org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$B/customN/
gsettings set $K name 'Dictate (local whisper)'
gsettings set $K command "$HOME/.local/bin/dictate-toggle"
gsettings set $K binding '<Super>slash'
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['$B/custom0/', '$B/customN/']"
```

Do not drop entries that were already in the list.
If `<Super>slash` is already taken, find the conflict with `gsettings list-recursively | grep -F '<Super>slash'` and ask the user before changing it.

## Use

Click into the target window, press Super+/ (a "listening" notification appears), speak, and press Super+/ again.
The transcript is typed after about a second.
Silence shows a "no speech detected" notification and types nothing.

## Test without typing

```bash
DICTATE_OUTPUT=print dictate-toggle   # start
DICTATE_OUTPUT=print dictate-toggle   # stop, prints the text
```

`DICTATE_OUTPUT` is `type` (default), `clipboard` (paste with Ctrl+Shift+V), or `print`.
Use `clipboard` if typing does not work on the machine.
