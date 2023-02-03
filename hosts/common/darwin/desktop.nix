{ ... }:
{
  services.yabai = {
    enable = true;
    config = {
      focus_follows_mouse = "off";
      mouse_follows_focus = "off";
      window_origin_display = "default";
      window_placement = "second_child";
      window_zoom_persist = "on";
      window_topmost = "off";
      window_shadow = "on";
      window_opacity = "off";
      window_opacity_duration = 0;
      active_window_opacity = 1;
      normal_window_opacity = 0.9;
      window_animation_duration = 0;
      window_animation_frame_rate = 120;
      insert_feedback_color = "0xffd75f5f";
      active_window_border_color = "0xff775759";
      normal_window_border_color = "0xff555555";
      window_border_width = 4;
      window_border_radius = 12;
      window_border_blur = "off";
      window_border_hidpi = "on";
      window_border = "off";
      split_ratio = 0.5;
      split_type = "auto";
      auto_balance = "off";
      top_padding = 10;
      bottom_padding = 10;
      left_padding = 10;
      right_padding = 10;
      window_gap = 10;
      layout = "bsp";
      mouse_modifier = "fn";
      mouse_action1 = "move";
      mouse_action2 = "resize";
      mouse_drop_action = "swap";

      # # apps to not manage (ignore)
      # yabai -m rule --add app="^System Settings$" manage=off
      # yabai -m rule --add app="^Archive Utility$" manage=off
      # yabai -m rule --add app="^Wally$" manage=off
      # yabai -m rule --add app="^Pika$" manage=off
      # yabai -m rule --add app="^balenaEtcher$" manage=off
      # yabai -m rule --add app="^Creative Cloud$" manage=off
      # yabai -m rule --add app="^Logi Options$" manage=off
      # yabai -m rule --add app="^Alfred Preferences$" manage=off
      # yabai -m rule --add app="Raycast" manage=off
      # yabai -m rule --add app="^Music$" manage=off
    };
  };

  services.skhd = {
    enable = true;
    skhdConfig = ''
      # focus window
      alt - h : yabai -m window --focus west
      alt - j : yabai -m window --focus south
      alt - k : yabai -m window --focus north
      alt - l : yabai -m window --focus east

      # swap managed window
      shift + alt - h : yabai -m window --swap west
      shift + alt - j : yabai -m window --swap south
      shift + alt - k : yabai -m window --swap north
      shift + alt - l : yabai -m window --swap east

      # move managed window
      shift + alt + ctrl - h : yabai -m window --warp west
      shift + alt + ctrl - j : yabai -m window --warp south
      shift + alt + ctrl - k : yabai -m window --warp north
      shift + alt + ctrl - l : yabai -m window --warp east

      # rotate tree
      alt - r : yabai -m space --rotate 90

      # toggle window fullscreen zoom
      alt - f : yabai -m window --toggle zoom-fullscreen

      # alt - s : yabai -m window --toggle
      alt - s : yabai -m window --toggle sticky;\
                yabai -m window --toggle topmost;\
                yabai -m window --toggle pip

      # toggle padding and gap
      alt - g : yabai -m space --toggle padding; yabai -m space --toggle gap

      # float / unfloat window and center on screen
      alt - t : yabai -m window --toggle float;\
                yabai -m window --grid 4:4:1:1:2:2

      # toggle window split type
      alt - e : yabai -m window --toggle split

      # balance size of windows
      shift + alt - 0 : yabai -m space --balance

      # move window and focus desktop
      shift + alt - 1 : yabai -m window --space 1; yabai -m space --focus 1
      shift + alt - 2 : yabai -m window --space 2; yabai -m space --focus 2
      shift + alt - 3 : yabai -m window --space 3; yabai -m space --focus 3
      shift + alt - 4 : yabai -m window --space 4; yabai -m space --focus 4
      shift + alt - 5 : yabai -m window --space 5; yabai -m space --focus 5
      shift + alt - 6 : yabai -m window --space 6; yabai -m space --focus 6
      shift + alt - 7 : yabai -m window --space 7; yabai -m space --focus 7
      shift + alt - 8 : yabai -m window --space 8; yabai -m space --focus 8
      shift + alt - 9 : yabai -m window --space 9; yabai -m space --focus 9


      # create desktop, move window and follow focus - uses jq for parsing json (brew install jq)
      shift + alt - n : yabai -m space --create && \
                         index="$(yabai -m query --spaces --display | jq 'map(select(."native-fullscreen" == 0))[-1].index')"&& \
                         yabai -m window --space "''${index}"&& \
                         yabai -m space --focus "''${index}"

      # fast focus desktop
      alt - tab : yabai -m space --focus recent

      # send window to monitor and follow focus
      shift + alt - n : yabai -m window --display next; yabai -m display --focus next
      shift + alt - p : yabai -m window --display previous; yabai -m display --focus previous
    '';
  };

  # services.spacebar = {
  #   enable = true;
  #   config = {
  #     clock_format = "%R";
  #     background_color = "0xff202020";
  #     foreground_color = "0xffa8a8a8";
  #   };
  # };
}
