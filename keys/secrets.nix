let
  thomas = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEidLI+MMkFILXXja+0M0IdtlLLUi8bVrHChzS8aVVNX";
  users = [ thomas ];

  thor = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINpKTrj5XDApmWLo2PpzBS3g8yn4G2CZlZUK/qgJFD2D";
  penguin = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG0MBjL4rlCI1e8M6wjg8PUEcRwk3onjspLSj6okCA8h";
  vault = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIHBZgMEAnSsMpS9zRVZT8PYuZTZr9KX6lBKW93Fz1w9";
  systems = [ thor penguin vault ];
in
{
  "cloudflare-token.age".publicKeys = [ thomas thor ];
  "wasabi-tokens.age".publicKeys = [ thomas thor ];
}
