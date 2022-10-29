{ ... }:
{
  programs.password-store = {
    enable = true;
    settings = {
      PASSWORD_STORE_KEY = "0xDE749C31D060A160";
    };
  };
};
