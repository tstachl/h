#!/run/current-system/sw/bin/bash
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

function usage {
  cat <<EOM
Usage: $(basename "$0") [options] <device> <mountpoint>

Options:
  -h          show usage information

Arguments:
  device      the disk device (eg. /dev/sda1)
  mountpoint  the mountpoint to mount btrfs (eg. /mnt)
EOM
  exit 0
}

while getopts ':h' opt; do
  case $opt in
    h) usage;;
    *) ;;
  esac
done

device=$( printf '%s\n' "${@:$OPTIND:1}" )
mount=$( printf '%s\n' "${@:$OPTIND+1:1}" )

if [ -z "$device" ]; then
  echo "Error: device is required (eg. /dev/sda)"
  exit 1
fi

if [ -z "$mount" ]; then
  echo "Error: mountpoint is required (eg. /mnt)"
  exit 1
fi

exists=true
if [ ! -d "$mount" ]; then
  exists=false
  mkdir "$mount"
fi

mount -o subvol=/ "$device" "$mount"

OLD_TRANSID=$(btrfs subvolume find-new /mnt/root-blank 9999999)
OLD_TRANSID=${OLD_TRANSID#transid marker was }

btrfs subvolume find-new "/mnt/root" "$OLD_TRANSID" |
  sed '$d' |
  cut -f17- -d' ' |
  sort |
  uniq |
  while read -r path; do
    path="/$path"
    if [ -L "$path" ]; then
      : # the path is a symbolic link, probably handled by nixos
    elif [ -d "$path" ]; then
      : # the path is a directory, ignore
    else
      echo "$path"
    fi
  done

umount "$mount"

if [[ "$exists" = false ]]; then
  rm -r "$mount"
fi

