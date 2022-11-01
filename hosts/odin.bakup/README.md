# Odin

## Responsibilities

* Password Manager
* Backup
* Git Backup


## Filesystem

### /boot/firmware

This is the first partition on the SD card or the usb hard drive. It'll contain
all the files required for booting from a Raspberry Pi. It'll be mounted with
the options `nofail` and `noauto` which should make this partition not show up
in the OS itself.

### /

The root filesystem will be mounted on `tempfs` because it'll be rebuilt on
every boot. This will allow the raspberry pi to keep the new machine smell.

### /nix

For nix and the nix store, we will use a btrfs subvol. File on here should be
persistent and changeable.

### /persist

There are certain files that need to be persisted in between boots like the host
keys of the machine. We'll be using a `nix-impermanence` configuration to store
the required files/folders on a persistent drive.

