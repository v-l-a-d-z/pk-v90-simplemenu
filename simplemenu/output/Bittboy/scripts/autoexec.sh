#!/bin/sh
find /mnt/.simplemenu -name '._*' -exec rm -v {} \;
cd /mnt/apps/simplemenu
./simplemenu
