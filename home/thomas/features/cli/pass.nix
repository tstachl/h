{ ... }:
{
  programs.password-store = {
    enable = true;
    settings = {
      PASSWORD_STORE_KEY = "0xDE749C31D060A160";
      PASSWORD_STORE_ENABLE_EXTENSIONS = "true";
    };
  };

  # systemd.user.services.pass-auto-init = {
  #   Unit.description = "Auto-Initialize Password Store";

  #   Service = {
  #     Type = "oneshot";
  #     ExecStart = with pkgs; ''
  #       text -d "$PASSWORD_STORE_DIR/.git" || ${git}/bin/git clone
  #       ${git}/bin/git
  #     '';
  #   };

  #   Install.WantedBy = [ "default.target" ];
  # };
}
