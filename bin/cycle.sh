#!/bin/sh

NEXTWIN="$(lsw | grep -v `pfw` | sed 1q)"

wtf $NEXTWIN
chwso -r $NEXTWIN
