{
  programs.rbw = {
    enable = true;
    settings = {
      email = "bw-cli@pilina.email";
      base_url = "https://warden.vault.pilina.com";
      lock_timeout = 300;
      pinentry = "tty";
    };
  };
}
