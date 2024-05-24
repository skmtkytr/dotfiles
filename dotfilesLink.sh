#!/bin/sh

SCRIPT_DIR=$(
	cd $(dirname $0)
	pwd
)

ln -sf $SCRIPT_DIR/config/nvim/init.vim ~/.vimrc
ln -sf $SCRIPT_DIR/.tmux.conf ~/.tmux.conf
ln -sf $SCRIPT_DIR/.gitconfig ~/.gitconfig
ln -sf $SCRIPT_DIR/config ~/.config
ln -sf $SCRIPT_DIR/.ctags ~/.ctags
ln -sf $SCRIPT_DIR/config/.wezterm.lua ~/.wezterm.lua
ln -sf $SCRIPT_DIR/.hammerspoon ~/.hammerspoon
ln -sf $SCRIPT_DIR/.asdfrc ~/.asdfrc
