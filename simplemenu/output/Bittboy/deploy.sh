#!/bin/sh
set -e
cat_main_content=$(cat /mnt/apps/simplemenu/main.sh)
# Step 1: Create the ".simplemenu" folder
if [ ! -d "/mnt/.simplemenu" ]; then
    mkdir /mnt/.simplemenu
fi

# Step 2: Copy the contents of "simplemenu" to ".simplemenu"
if [ -d "/mnt/apps/simplemenu" ]; then
    cp -r /mnt/apps/simplemenu/config/* /mnt/.simplemenu/
    cp -r /mnt/apps/simplemenu/* /mnt/.simplemenu/
    rm -fr /mnt/.simplemenu/config/*
    rm -fr /mnt/.simplemenu/deploy.sh /mnt/.simplemenu/main.sh
fi

# Step 3: Copy "autoexec.sh" one folder upwards
if [ -f "/mnt/.simplemenu/autoexec.sh" ]; then
    cp /mnt/.simplemenu/autoexec.sh /mnt/
fi

# Step 4: Autobooting simplemenu
#if [ -f "/etc/main" ]; then
#     mount -o remount,rw,noauto /dev/root
#    if [ -n "$cat_main_content" ]; then
#           echo "$cat_main_content" > /etc/main
#    fi
#fi

sync
sleep 3
poweroff
exit