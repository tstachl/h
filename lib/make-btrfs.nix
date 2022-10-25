# Builds a btrfs image containing a populated /nix/store with the closure
# of store paths passed in the storePaths parameter, in addition to the
# contents of a directory that can be populated with commands. The
# generated image is sized to only fit it's contents, with the expectation
# that a script resizes the filesystem at boot time.
{ pkgs
, lib
# List of derivations to be included
, storePaths
# Wether or not to compress the resulting image with zstd
, compressImage ? false, zstd
# Shell commands to populate the ./files directory.
# All files in the directory are copied to the root of the FS.
, populateImageCommands ? ""
, volumeLabel
, uuid ? "44444444-4444-4444-8888-888888888888"
, e2fsprogs
, libfaketime
, perl
, fakeroot
}:

let
  sdClosureInfo = pkgs.buildPackages.closureInfo { rootPaths = storePaths; };
in
pkgs.stdenv.mkDerivation {
  name = "btrfs.img${lib.optionalString compressImage ".zst"}";

  nativeBuildInputs = [ e2fsprogs.bin libfaketime perl fakeroot ]
  ++ lib.optional compressImage zstd;

  buildCommand =
    ''
    # do we know the subvols for btrfs? do we have access to fileSystem?

    ${if compressImage then "img=tmp.img" else "img=$out"}
    (
      mkdir -p ./files
      ${populateImageCommands}
    )

    echo "Preparing store paths for image..."

    # Create nix/store before copying path

    '';
}
