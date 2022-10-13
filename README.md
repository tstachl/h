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

## sops-nix

For testing purposes I've been setting up [sops-nix](https://github.com/Mic92/sops-nix)
on the `throwaway` machine. First, I create a `.sops.yaml` file in the `root`
directory containing the fingerprint of my personal GPG key and an age key
converted from the SSH Ed25519 public key of the host machine. Generating those
host keys is a step that needs to be taken whenever a new host is added and at
the moment I'm still unclear of the correct sequence of steps.

To generate the age key I ran:

```
nix-shell -p ssh-to-age --run 'ssh-keyscan 192.168.64.6 | ssh-to-age'
```

Once the keys is added, I think you'd also have to run sops again to encrypt the
screts with the new combination of keys. To do that, I ran:

```
[thomas]$ nix-shell shell.nix
[thomas@nix-shell]$ sops hosts/common/secrets.yaml
```

With that, the password file for my users has been decrypted on `throwaway` in
the folder `/run/secrets-for-users/thomas`. However, for some reason, on reboot
I was unable to log in. Before continuing to investigate, I wanted to jot down
these steps while it was fresh on my mind.
