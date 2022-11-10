let
  thomas = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEidLI+MMkFILXXja+0M0IdtlLLUi8bVrHChzS8aVVNX";
  users = [ thomas ];

  thor = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINpKTrj5XDApmWLo2PpzBS3g8yn4G2CZlZUK/qgJFD2D";
  throwaway = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPl8524nt4nERZLdrJg29pEUZlW1mnxgG+joc3qapHWc";
  systems = [ thor throwaway ];
in
{
  "cloudflare-token.age".publicKeys = [ thomas thor ];
  "wasabi-tokens.age".publicKeys = [ thomas thor ];
}
