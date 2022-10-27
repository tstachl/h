{ writeShellApplication }:
writeShellApplication {
  name = "hparted";
  text = builtins.readFile ./hparted.sh;
}
