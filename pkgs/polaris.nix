{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "polaris";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "agersant";
    repo = pname;
    rev = "master";
    sha256 = "sha256-ATseY6viO7MWogtXI4n85mptHjc5MJEXjkHtG8rYdCQ=";
  };

  cargoSha256 = "sha256-iizOwM1fYAEdBf4Sw3lS2MLNM8tX61DL868v3oElRiA=";

  meta = with lib; {
    description = "Polaris is a music streaming application, designed to let you enjoy your music collection from any computer or mobile device.";
    homepage = "https://github.com/agersant/polaris";
    license = licenses.mit;
    maintainers = [ ];
  };
}
