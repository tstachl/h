{ writeShellApplication }:
writeShellApplication {
  name = "hparted";
  text = builtins.readFile ./parted.sh;
}
