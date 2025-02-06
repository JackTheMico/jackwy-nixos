{monitor, gpucard, ...}: {
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$terminal" = "kitty";
      "$fileManager" = "nautilus";
      "$menu" = "wofi --show drun";
      "$mod" = "SUPER";
      bindm = [
        # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
        "$mod, Q, exec, $terminal"
        "$mod, C, killactive"
        "$mod, M, exit"
        "$mod, E, exec, $fileManager"
        "$mod, V, togglefloating"
        "$mod, R, exec, $menu"
        "$mod, P, pseudo, # dwindle"
        "$mod, J, togglesplit, # dwindle"
        # Move focus with mod + arrow keys
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
	"$mod , 0, workspace, 10"
	"$mod , SHIFT, 0, movetoworkspace, 10"

        # Example special workspace (scratchpad)
        "$mod, S, togglespecialworkspace, magic"
        "$mod SHIFT, S, movetoworkspace, special:magic"
        # Scroll through existing workspaces with mod + scroll
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"
        # Move/resize windows with mod + LMB/RMB and dragging
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
        # Laptop multimedia keys for volume and LCD brightness
        "bindel = ,XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        "bindel = ,XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        "bindel = ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        "bindel = ,XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        "bindel = ,XF86MonBrightnessUp, exec, brightnessctl s 10%+"
        "bindel = ,XF86MonBrightnessDown, exec, brightnessctl s 10%-"
        # Requires playerctl
        "bindl = , XF86AudioNext, exec, playerctl next"
        "bindl = , XF86AudioPause, exec, playerctl play-pause"
        "bindl = , XF86AudioPlay, exec, playerctl play-pause"
        "bindl = , XF86AudioPrev, exec, playerctl previous"
      ] ++ (
        # workspaces
        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (builtins.genList (i:
            let ws = i + 1;
            in [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          )
          9)
      );
      monitor = monitor;
      env = {
        XCURSOR_SIZE = 24;
        HYPRCURSOR_SIZE = 24;
        AQ_DRM_DEVICES = gpucard;
      };

      gestures = {
        workspace_swipe = true;
      };
      animations = {
        enabled = true;
      };

      decoration = {
        rounding = 10;
	active_opacity = 1.0;
	inactive_opacity = 0.7;

        shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
            color = "rgba(1a1a1aee)";
        };
        blur = {
            enabled = true;
            size = 3;
            passes = 1;
            vibrancy = 0.1696;
        };

      };
      input = {
        kb_layout = "us";
        follow_mouse = 1;
        kb_options = "ctrl:nocaps";
        touchpad = {
          natural_scoll = true;
        };
      };
    };
  };
}
