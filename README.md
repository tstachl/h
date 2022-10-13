# h


## Installation
### NixOS

```sh
# Become root
sudo -i

# UEFI (GPT)
parted /dev/vda -- mklabel gpt
parted /dev/vda -- mkpart primary 512mb 100%
parted /dev/vda -- mkpart ESP fat32 1mb 512mb
parted /dev/vda -- set 2 esp on

# Formatting
mkfs.btrfs -fL throwaway /dev/vda1
mkfs.fat -F 32 -n boot /dev/vda2

# Mount partitions
mount /dev/disk/by-label/throwaway /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot

# Install from flake
nixos-install --flake github:tstachl/h#throwaway
```

### Home Manager
```sh
nix build --no-link github:tstachl/h#homeConfigurations.$USER@$(hostname).activationPackage
cd $(nix path-info github:tstachl/h#homeConfigurations.$USER@$(hostname).activationPackage)
./activate
```

## Update
### NixOS

```sh
sudo nixos-rebuild switch --flake github:tstachl/h#$(hostname)
```

### Home Manager

```sh
home-manager switch --flake github:tstachl/h#$USER@$(hostname)
```
