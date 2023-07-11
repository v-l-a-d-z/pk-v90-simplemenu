#!/bin/sh
find /mnt/ -name '._*' -exec rm -v {} \;
cd /mnt/apps/simplemenu
./simplemenu
