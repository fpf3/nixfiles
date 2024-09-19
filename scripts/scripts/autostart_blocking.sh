#!/bin/sh
autorandr --load default

if [ -e $HOME/.Xresources]; then
    xrdb $HOME/.Xresources
fi

wal -R
xset b off
