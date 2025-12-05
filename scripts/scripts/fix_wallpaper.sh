#!/bin/sh

BGSCRIPT=$HOME/.fehbg

if [ -e $BGSCRIPT ]; then
    exec $HOME/.fehbg
fi
