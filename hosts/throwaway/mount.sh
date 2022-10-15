#!/run/current-system/sw/bin/sh
set -e

# Check that $1 exists
if [ ! -b "$1" ]; then
  echo "`$1` does not exist."
  exit 1
fi

# Mount Everything
sudo mount -o subvol=root,compress=zstd,noatime "$1" /mnt

sudo mkdir /mnt/home
sudo mount -o subvol=home,compress=zstd,noatime "$1" /mnt/home

sudo mkdir /mnt/nix
sudo mount -o subvol=nix,compress=zstd,noatime "$1" /mnt/nix

sudo mkdir /mnt/persist
sudo mount -o subvol=persist,compress=zstd,noatime "$1" /mnt/persist

sudo mkdir /mnt/swap
sudo mount -o subvol=swap,compress=noatime "$1" /mnt/swap

sudo mkdir /mnt/boot
sudo mount /dev/disk/by-label/boot /mnt/boot

