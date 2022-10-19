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

while getopts ':ecmh' opt; do
  case $opt in
    c) create=true;;
#    e) encrypt=true;;
    m) mount=true;;
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

# cat << EOM
# 
# create=$create
# encrypt=$encrypt
# mount=$mount
# device=$device
# hostname=$hostname
# 
# EOM

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
  mkfs.btrfs -fL "$hostname" "${device}1"
  mkfs.fat -F 32 -n boot "${device}2"

  # ln -s "${device}1" /dev/mapper/$hostname

  # Mount and Setup BTRFS
  mount -t btrfs "${device}1" /mnt

  # Create Subvolumes
  btrfs subvolume create /mnt/root
  btrfs subvolume create /mnt/home
  btrfs subvolume create /mnt/nix
  btrfs subvolume create /mnt/persist
  btrfs subvolume create /mnt/swap

  # Take a Blank Snapshot
  btrfs subvolume snapshot -r /mnt/root /mnt/root-blank

  # BTRFS done
  umount /mnt
fi

if [ "$mount" = true ]; then
  # Mount Everything
  mount -o subvol=root,compress=zstd,noatime "/dev/disk/by-label/$hostname" /mnt
  
  [ ! -d "/mnt/home" ] && mkdir /mnt/home
  mount -o subvol=home,compress=zstd,noatime "/dev/disk/by-label/$hostname" /mnt/home
  
  [ ! -d "/mnt/nix" ] && mkdir /mnt/nix
  mount -o subvol=nix,compress=zstd,noatime "/dev/disk/by-label/$hostname" /mnt/nix
  
  [ ! -d "/mnt/persist" ] && mkdir /mnt/persist
  mount -o subvol=persist,compress=zstd,noatime "/dev/disk/by-label/$hostname" /mnt/persist
  
  [ ! -d "/mnt/swap" ] && mkdir /mnt/swap
  mount -o subvol=swap,compress=noatime "/dev/disk/by-label/$hostname" /mnt/swap
  
  [ ! -d "/mnt/boot" ] && mkdir /mnt/boot
  mount /dev/disk/by-label/boot /mnt/boot
fi

