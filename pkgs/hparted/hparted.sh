#!/run/current-system/sw/bin/bash
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

function usage {
  cat <<EOM
Usage: $(basename "$0") [options] <device> <hostname>

Options:
  -c          create partitions
  -m          mount partitions
  -z          use zfs instead of btrfs
  -h          show usage information

Arguments:
  device      the disk device (eg. /dev/sda)
  hostname    the hostname for this machine
EOM
  exit 0
}

create=false
#encrypt=false
mount=false
zfs=false

while getopts ':cmzh' opt; do
  case $opt in
    c) create=true;;
#    e) encrypt=true;;
    m) mount=true;;
    z) zfs=true;;
    h) usage;;
    *) ;;
  esac
done

device=$( printf '%s\n' "${@:$OPTIND:1}" )
hostname=$( printf '%s\n' "${@:$OPTIND+1:1}" )

if [ -z "$device" ]; then
  echo "Error: device is required (eg. /dev/sda)"
  exit 1
fi

if [ -z "$hostname" ]; then
  echo "Error: hostname is required (eg. throwaway)"
  exit 1
fi

if [[ "$create" = true ]]; then
  # Creating Partitions
  parted "$device" -- mklabel gpt
  parted "$device" -- mkpart primary 512mb 100%
  parted "$device" -- mkpart ESP fat32 1mb 512mb
  parted "$device" -- set 2 esp on

  # # Set up encryption
  # #cryptsetup --verify-passphrase -v luksFormat --label=${hostname}_crypt "${device}1"
  # #cryptsetup open "${device}1" $2

  # Formatting Partitions
  #mkfs.btrfs -fL $2 /dev/mapper/$2
  mkfs.fat -F 32 -n boot "${device}2"

  # ln -s "${device}1" /dev/mapper/$hostname

  if [ "$zfs" = true ]; then
    zpool create -O compress=on -O mountpoint=legacy "$hostname" "${device}1" -f
    zfs create -o xattr=off -o atime=off "${hostname}/nix"
    zfs create -o xattr=off -o atime=off "${hostname}/persist"
  else
    mkfs.btrfs -fL "$hostname" "${device}1"

    # Mount and Setup BTRFS
    mount -t btrfs "${device}1" /mnt

    # Create Subvolumes
    btrfs subvolume create /mnt/nix
    btrfs subvolume create /mnt/persist
    btrfs subvolume create /mnt/swap

    # BTRFS done
    umount /mnt
  fi
fi

if [ "$mount" = true ]; then
  # Mount Everything
  mount -t tmpfs -o defaults,mode=755 none /mnt

  [ ! -d "/mnt/nix" ] && mkdir /mnt/nix
  [ ! -d "/mnt/persist" ] && mkdir /mnt/persist

  if [ "$zfs" = true ]; then
    mount -t zfs "${hostname}/nix" /mnt/nix
    mount -t zfs "${hostname}/persist" /mnt/persist
  else
    mount -o subvol=nix,compress=zstd,noatime "/dev/disk/by-label/$hostname" /mnt/nix
    mount -o subvol=persist,compress=zstd,noatime "/dev/disk/by-label/$hostname" /mnt/persist

    [ ! -d "/mnt/swap" ] && mkdir /mnt/swap
    mount -o subvol=swap,compress=noatime "/dev/disk/by-label/$hostname" /mnt/swap
  fi

  [ ! -d "/mnt/boot" ] && mkdir /mnt/boot
  mount /dev/disk/by-label/boot /mnt/boot
fi

