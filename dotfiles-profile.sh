# copy to /etc/profile.d and make sure it runs on login
export DOTFILES_DIR="$HOME/.dotfiles"

if [ -r $DOTFILES_DIR/init.sh ]; then
    . $DOTFILES_DIR/init.sh
fi