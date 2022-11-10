{ config, pkgs, lib, ... }:

with lib;

let
  # TODO: find a way to get this from /lib/systemd-unit-options.nix
  unitOption = mkOptionType {
    name = "systemd option";
    merge = loc: defs:
      let
        defs' = filterOverrides defs;
        defs'' = getValues defs';
      in
        if isList (head defs'')
        then concatLists defs''
        else mergeEqualOption loc defs';
  };

  sanitizeName = name:
    replaceStrings
      [ "." ] [ "" ]
      (strings.sanitizeDerivationName (removePrefix "/" (toLower name)));

  cfg = config.services.s3fs;
in rec {
  options.services.s3fs = {
    enable = mkEnableOption "s3fs";

    mounts = mkOption {
      default = {};

      type =
        let
          inherit (types) attrsOf bool submodule path str;
        in
        attrsOf (
          submodule (
            { name, ... }:
            let
              mountpoint = name;
            in {
              options = {
                mountpoint = mkOption {
                  type = path;
                  default = mountpoint;
                  example = "/mnt/data";
                  description = ''
                    The path to where the remote should be mounted.
                  '';
                };

                bucket = mkOption {
                  type = str;
                  default = "";
                  example = "mybucket";
                  description = ''
                    The name of the remote defined in
                    settings.
                  '';
                };

                path = mkOption {
                  type = path;
                  default = "";
                  example = "/path/to/data";
                  description = ''
                    The remote path to the files for
                    this mountpoint.
                  '';
                };

                automount = mkOption {
                  type = bool;
                  default = false;
                  description = ''
                    Set to true if you want the mount
                    to happen automatically.
                  '';
                };

                passwd_file = mkOption {
                  type = path;
                  default = "/etc/passwd-s3fs";
                  example = "/path/to/passwd-s3fs";
                  description = ''
                    The path to the s3fs password file.
                  '';
                };

                url = mkOption {
                  type = str;
                  default = "https://s3.amazonaws.com";
                  example = "https://url.to.s3";
                  description = ''
                    The s3 url.
                  '';
                };

                mountConfig = mkOption {
                  default = {};
                  example = { DirectoryMode = "0775"; };
                  type = types.attrsOf unitOption;
                  description = ''
                    Each attribute in this set specifies an option in the
                    <literal>[Mount]</literal> section of the unit.  See
                    <citerefentry><refentrytitle>systemd.mount</refentrytitle>
                    <manvolnum>5</manvolnum></citerefentry> for details.
                  '';
                };
              };
            }
          )
        );
      example = literalExpression ''
        {
          "/path/to/files" = {
            bucket = "mybucket";
            path = "/path/to/files";
            passwd_file = "/path/to/passwd-s3fs";
            automount = true;
          };
        }
      '';
      description = ''
        Creates mount units to mount remotes to the local filesystem. This
        option specifies the remote and the mountpoint for each mount.
      '';
    };
  };

  # implementation
  config = mkIf cfg.enable {
    systemd = {
      mounts = let
        mkS3Mount = { mountpoint, bucket, path, passwd_file, url, mountConfig, ... }:
          let
            what = "${bucket}:${path}";
          in
          {
            description = "s3fs mount ${what} to ${mountpoint}";
            after = [ "network-online.target" ];
            type = "s3fs";
            what = what;
            where = mountpoint;
            options = "rw,allow_other,passwd_file=${passwd_file},url=${url},use_cache=/tmp/s3fs";
            mountConfig = mountConfig;
          };
      in
      map mkS3Mount (attrValues cfg.mounts);

      automounts = let
        mkS3Auto = { mountpoint, bucket, path, ... }:
          let
            what = "${bucket}:${path}";
          in
          {
            description = "s3fs automount ${what} to ${mountpoint}";
            after = [ "network-online.target" ];
            before = [ "remote-fs.target" ];
            where = mountpoint;
            automountConfig = {
              TimeoutIdleSec = 600;
            };
            wantedBy = [ "multi-user.target" ];
          };
      in
      map mkS3Auto (filter (el: el.automount) (attrValues cfg.mounts));
    };

    environment.systemPackages = [
      pkgs.s3fs
    ];
# AssertPathIsDirectory=/mnt/s3fs
# -o url=https://nyc3.digitaloceanspaces.com -o use_cache=/tmp -o allow_other -o use_path_request_style -o uid=1000 -o gid=1000
# ExecStop=/bin/fusermount -u /mnt/s3fs
#
# [Install]
# WantedBy=default.target
  };
}
