export DOTFILES_DIR="$HOME/.dotfiles"

if [ -d "$DOTFILES_DIR" ]; then
    for i in $(find $DOTFILES_DIR/profile.d -type f -name "*.zsh"); do
        if [ -r $i ]; then
            . $i
        fi
    done
fi
