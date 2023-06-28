#!/bin/sh
set -e

boot_logo_path="/mnt/boot-logo"

export HOME="/mnt"
export SDL_NOMOUSE="1"

start_script_path="/mnt/autoexec.sh"

echo -e "\e[?1c" #replace 1 with 3 to see text
#/mnt/kernel/setcolors /mnt/kernel/colors

modprobe r61520fb.ko

# Detect low battery and prevent booting up if so
if test "$(cat /sys/class/power_supply/miyoo-battery/voltage_now)" -lt '3400'; then
  clear; echo -e "\n\n\n\n\n\n\n\n\n\n\n\n\n\n            \e[1;33m[ LOW BATTERY ]\e[0m"
  sync
  sleep 3
  poweroff
  exit
fi

#Check if fat32 is flagged as "dirty", and if so unmount, repair, remount
if dmesg | grep "mmcblk0p4" > /dev/null; then
  echo -en "\e[31mUnclean shutdown detected.\e[0m\n\e[32mChecking FAT32 partition...\e[0m\n"
  #Detect if partition is being mounted or not, and if it is mounted, unmount as usual, and if not, continue
  if mountpoint -q /mnt; then
    umount /dev/mmcblk0p4
  fi
  fsck.vfat -y /dev/mmcblk0p4 > /dev/null
  mount /dev/mmcblk0p4 /mnt -t vfat -o rw,sync,utf8
  echo -e "\e[32mCheck complete.\e[0m\n"
fi

/mnt/kernel/daemon > /dev/null 2>&1

function check_battery {
  while true; do
    sleep 300
    if test "$(cat /sys/class/power_supply/miyoo-battery/voltage_now)" -lt '3400'; then
      clear; echo -e "\n\n\n\n\n\n\n\n\n\n\n\n\n\n            \e[1;33m[ LOW BATTERY ]\e[0m"
      kill -TERM "${1}"
    fi
  done
}

while true; do
    if [ -f "$start_script_path" ]; then
        . "$start_script_path"
    else
        cd "/mnt/gmenu2x"
        ./gmenu2x > /dev/null 2>&1
    fi
    clear
    pid="${!}"
    sleep 3
    clear; echo -e "\n\n\n\n\n\n\n\n\n\n\n\n\n\n               \e[1;33m[ SAVING ]\e[0m"
    check_battery "${pid}" &
    wait "${pid}"
    sync
    poweroff
done