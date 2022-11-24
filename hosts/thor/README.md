# thor

This is my always on work horse. It runs all of the services I use on my devices.

## Preparing Oracle Cloud

These steps are taken from a [blog post by Korfuri](https://blog.korfuri.fr/posts/2022/08/nixos-on-an-oracle-free-tier-ampere-machine/)

1. Install nix package manager `sh <(curl -L https://nixos.org/nix/install) --daemon`
2. Clone git repo `git clone https://github.com/cleverca22/nix-tests.git`
3. Create a config `vim nix-tests/kexec/myconfig.nix`

```
{
  imports = [
    ./configuration.nix
  ];
  # Make it use predictable interface names starting with eth0
  boot.kernelParams = [ "net.ifnames=0" ];
  networking.useDHCP = true;
  kexec.autoReboot = false;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAredactedZZZ"
  ];
}
```

4. Build the tarball `nix-build '<nixpkgs/nixos>' -A config.system.build.kexec_tarball -I nixos-config=./myconfig.nix`
5. Unpack the tarball `tar -xf ./result/tarball/nixos-system-aarch64-linux.tar.xz`
6. Run the kexec `sudo ./kexec_nixos`
7. Wait for `+ kexec -e`
8. Hit `enter`, `~`, `.`
9. Remove existing entries from `known_hosts`
10. Reconnect as root
11. Continue with regular nixos installation
