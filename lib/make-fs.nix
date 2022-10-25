# Builds an image containing a populated /nix/store with the closure
# of store paths passed in the storePaths parameter, in addition to the
# contents of a directory that can be populated with commands. The
# generated image is sized to only fit its contents, with the expectation
# that a script resizes the filesystem at boot time.
{ pkgs
, lib
# List of derivations to be included
, storePaths
# Whether or not to compress the resulting image with zstd
, compressImage ? false, zstd
# Shell commands to populate the ./files directory.
# All files in that directory are copied to the root of the FS.
, populateImageCommands ? ""
, volumeLabel
, fileSystems
, uuid ? "44444444-4444-4444-8888-888888888888"
}:

let
  # check if we're building for ext4 or btrfs and pull the correct derivation
  mkFileSystems = pkgs.callPackage ./make-ext4-fs.nix {
    inherit storePaths;
    inherit compressImage;
    inherit populateImageCommands;
    inherit volumeLabel;
    inherit uuid;
  };
in
pkgs.callPackage ./make-ext4-fs.nix {
  inherit storePaths;
  inherit compressImage;
  inherit populateImageCommands;
  inherit volumeLabel;
  inherit uuid;
}
