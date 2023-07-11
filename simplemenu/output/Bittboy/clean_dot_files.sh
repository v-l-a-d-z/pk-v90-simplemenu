#!/bin/sh
set -e
echo "Cleaning dot files..."
find /mnt/ -name '._*' -exec rm -v {} \;
echo "Finished task! Closing..."
sync
sleep 3
exit 0