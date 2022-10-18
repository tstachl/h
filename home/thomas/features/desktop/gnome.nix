{ pkgs, ... }:
{
  home.packages = (with pkgs; [
    # TODO: add this when material-shell-26 is available
    # gnomeExtensions.material-shell
  ]);

  dconf.settings = {
    "org/gnome/desktop/peripherals/mouse" = {
      natural-scroll = true;
      accel-profile = "flat";
    };

    "org/gnome/shell/extensions/materialshell/bindings" = {
      previous-window = ["<Super>H"];
      next-window = ["<Super>L"];
      app-launcher = ["<Super>Space"];
      kill-focused-window = ["<Super>Q"];

      move-window-left = ["<Super><Shift>H"];
      move-window-right = ["<Super><Shift>L"];
      move-window-up = ["<Super><Shift>K"];
      move-window-down = ["<Super><Shift>J"];

      # focus-monitor-left = ["<Alt><Super>Left"];
      # focus-monitor-right = ["<Alt><Super>Right"];
      # focus-monitor-up = ["<Alt><Super>Up"];
      # focus-monitor-down = ["<Alt><Super>Down"];

      # move-window-monitor-left = ["<Shift><Super>Left"];
      # move-window-monitor-right = ["<Shift><Super>Right"];
      # move-window-monitor-up = ["<Shift><Super>Up"];
      # move-window-monitor-down = ["<Shift><Super>Down"];

      resize-window-left = ["<Alt><Super>H"];
      resize-window-right = ["<Alt><Super>L"];
      resize-window-up = ["<Alt><Super>K"];
      resize-window-down = ["<Alt><Super>J"];

      move-window-to-workspace-1 = ["<Shift><Super>1"];
      move-window-to-workspace-2 = ["<Shift><Super>2"];
      move-window-to-workspace-3 = ["<Shift><Super>3"];
      move-window-to-workspace-4 = ["<Shift><Super>4"];
      move-window-to-workspace-5 = ["<Shift><Super>5"];
      move-window-to-workspace-6 = ["<Shift><Super>6"];
      move-window-to-workspace-7 = ["<Shift><Super>7"];
      move-window-to-workspace-8 = ["<Shift><Super>8"];
      move-window-to-workspace-9 = ["<Shift><Super>9"];
      move-window-to-workspace-10 = ["<Shift><Super>0"];
     
      cycle-tiling-layout = ["<Super>I"];
      reverse-cycle-tiling-layout = ["<Shift><Super>I"];
      toggle-material-shell-ui = ["<Super>Escape"];
      
      use-maximize-layout = [""];
      use-split-layout = [""];
      use-half-layout = [""];
      use-half-horizontal-layout = [""];
      use-half-vertical-layout = [""];
      use-grid-layout = [""];
      use-ratio-layout = [""];
      use-float-layout = [""];
      use-simple-layout = [""];
      use-simple-horizontal-layout = [""];
      use-simple-vertical-layout = [""];

      previous-workspace = ["<Super>wk"];
      next-workspace = ["<Super>wj"];
      last-workspace = ["<Super>z"];

      navigate-to-workspace-1 = ["<Super>1"];
      navigate-to-workspace-2 = ["<Super>2"];
      navigate-to-workspace-3 = ["<Super>3"];
      navigate-to-workspace-4 = ["<Super>4"];
      navigate-to-workspace-5 = ["<Super>5"];
      navigate-to-workspace-6 = ["<Super>6"];
      navigate-to-workspace-7 = ["<Super>7"];
      navigate-to-workspace-8 = ["<Super>8"];
      navigate-to-workspace-9 = ["<Super>9"];
      navigate-to-workspace-10 = ["<Super>0"];
    };
  };
}
