{
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot = {
      enable = true;
      editor = false;
      consoleMode = "max";
    };
    timeout = 0;
  };
}
