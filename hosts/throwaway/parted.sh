#!/run/current-system/sw/bin/sh
set -e

# Check that $1 exists
if [ ! -b "$1" ]; then
  echo "`$1` does not exist."
  exit 1
fi

# Creating Partitions
sudo parted $1 -- mklabel gpt
sudo parted $1 -- mkpart primary 512mb 100%
sudo parted $1 -- mkpart ESP fat32 1mb 512mb
sudo parted $1 -- set 2 esp on

# Set up encryption
sudo cryptsetup --verify-passphrase -v luksFormat "${1}1"
sudo cryptsetup open "${1}1" enc

# Formatting Partitions
sudo mkfs.btrfs -fL nixos /dev/mapper/enc
sudo mkfs.fat -F 32 -n boot "${1}2"

# Mount and Setup BTRFS
sudo mount -t btrfs /dev/mapper/enc /mnt

# Create Subvolumes
sudo btrfs subvolume create /mnt/root
sudo btrfs subvolume create /mnt/home
sudo btrfs subvolume create /mnt/nix
sudo btrfs subvolume create /mnt/persist
sudo btrfs subvolume create /mnt/swap

# Take a Blank Snapshot
sudo btrfs subvolume snapshot -r /mnt/root /mnt/root-blank

# BTRFS done
sudo umount /mnt

# Mount Everything
sudo mount -o subvol=root,compress=zstd,noatime /dev/mapper/enc /mnt

sudo mkdir /mnt/home
sudo mount -o subvol=home,compress=zstd,noatime /dev/mapper/enc /mnt/home

sudo mkdir /mnt/nix
sudo mount -o subvol=nix,compress=zstd,noatime /dev/mapper/enc /mnt/nix

sudo mkdir /mnt/persist
sudo mount -o subvol=persist,compress=zstd,noatime /dev/mapper/enc /mnt/persist

sudo mkdir /mnt/swap
sudo mount -o subvol=swap,compress=noatime /dev/mapper/enc /mnt/swap

sudo mkdir /mnt/boot
sudo mount /dev/disk/by-label/boot /mnt/boot
