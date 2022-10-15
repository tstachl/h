#!/run/current-system/sw/bin/sh
set -e

full_path=$(realpath $0)
dir_path=$(dirname $full_path)
device=$1
hostname=$2

# Check that device exists
if [ ! -b "$device" ]; then
  echo "`$device` does not exist."
  exit 1
fi

# Check hostname is given
if [ -z "$hostname" ]; then
  echo "You have to specify a hostname."
  exit 1
fi

# Creating Partitions
sudo parted $device -- mklabel gpt
sudo parted $device -- mkpart primary 512mb 100%
sudo parted $device -- mkpart ESP fat32 1mb 512mb
sudo parted $device -- set 2 esp on

# Set up encryption
#sudo cryptsetup --verify-passphrase -v luksFormat --label=${2}_crypt "${device}1"
#sudo cryptsetup open "${device}1" $2

# Formatting Partitions
#sudo mkfs.btrfs -fL $2 /dev/mapper/$2
sudo mkfs.btrfs -fL $hostname "${device}1"
sudo mkfs.fat -F 32 -n boot "${device}2"

sudo ln -s "${device}1" /dev/mapper/$hostname

# Mount and Setup BTRFS
sudo mount -t btrfs /dev/mapper/$hostname /mnt

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

# Mount everything
sh -c "sudo $dir_path/mount.sh /dev/mapper/$hostname"

