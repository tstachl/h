# h


## Installation
### NixOS

```sh
# Load the development shell from nix
nix --experimental-features "nix-command flakes" develop github:tstachl/h

# Clone the repository
git clone git@github.com:tstachl/h

# Run the partition script
cd h && \
  sudo hosts/throwaway/parted.sh /dev/vda throwaway

# Install the OS
sudo nixos-install --flake .#throwaway

# Create and/or move host keys
gpg --out hosts/throwaway/keys.tar.gz --decrypt hosts/throwaway/keys.tar.gz.gpg
sudo tar -xvzf hosts/throwaway/keys.tar.gz /mnt/etc/ssh
sudo cp hosts/throwaway/*.pub /mnt/etch/ssh
rm hosts/throwaway/keys.tar.gz

# Recreate and/or apply secrets
sudo nixos-install --flake .#throwaway
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

### Host Keys

Since `sops-nix` uses the host keys to decrypt secrets, I'm going to have to
backup and restore those host keys for every host I'm creating. It would be
great if I could just say `nixos-install --flake github:tstachl/h#throwaway` and
have it automagically restore the host keys. But its seems like it might be more
difficult than that. Here are some options I'm investigating:

1. Activation Scripts

2. Manual backup & restore

## Odin SD Card

The nixos configuration for `odin` gives the option to build an sd card with the
following command:

```sh
nix build .#nixosConfigurations.odin.config.system.build.sdImage
```

## Filesystem Setup

### Ext4 vs Btrfs

In my opinion Btrfs is the clear winner when choosing a fileystem. Especially
since it also allows for deduplication which saves space. I only have 128 GB
internal disk space on `penguin`, which can be extended with a micro sd card.
And seeing that Btrfs allows you to span a filesystem over multiple devices,
this might also come in handy in the future.

### Tmpfs

For root, I want to utilize tmpfs. It get's wiped and freshly set up with every
boot of the computer. Only specificly defined directories and folders should be
persisted.

```nix
{
  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = [ "defaults" "size=2G" "mode=755" ];
    };

    "/nix" = {
      device = "/dev/disk/by-label/${hostname}";
      fsType = "btrfs";
      options = [ "subvol=n" "compress=zstd" "noatime" ];
    };

    "/p" = {
      device = "/dev/disk/by-label/${hostname}";
      fsType = "btrfs";
      options = [ "subvol=p" "compress=zstd" "noatime" ];
    };

    "/s" = {
      device = "/dev/disk/by-label/${hostname}";
      fsType = "btrfs";
      options = [ "subvol=s" "noatime" "nodatacow" ];
    };
  };
}
```

## Steps after install
1. if required login to tailscale
2. if required login to github

## GPG Forward Agent
1. login to remote server
2. stop gpg-agent `killall gpg-agent`
3. exit and re-login to remote server

This should have created the gpg-agent socket folder, it should have removed all
the sockets from the folder and re-create the default agent socket forwarded.

## Services I want to run

* password manager?
* syncthing
* file manager
* music streaming?
* video streaming?
* git repositories

