{ writeShellApplication }:
writeShellApplication {
  name = "fs-diff";
  text = builtins.readFile ./fs-diff.sh;
}
