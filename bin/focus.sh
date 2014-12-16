#!/bin/sh

[ -n "$1" ] || exit 1
case $1 in
    left)   V='x' SO='r';;
    down)   V='y';;
    up)     V='y' SO='r';;
    right)  V='x';;
esac

VAL=$(wattr $V $(lsw) | sort -un$SO | grep $(wattr $V $(pfw)) -A1 | sed -n 2p)

[ "$VAL" == "" ] && exit 1
for WID in $(lsw)
do
    [ $(wattr $V $WID) -eq $VAL ] && SELWIN=$WID
    [ -n "$SELWIN" ] && break
done

[ -n "$SELWIN" ] && wtf $SELWIN
[ -n "$SELWIN" ] && chwso -r $SELWIN

exit 0
