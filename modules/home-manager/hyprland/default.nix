{moduleNameSpace, ...}: {pkgs, lib, config, ...}: with lib;
let
  cfg = config.${moduleNameSpace}.hyprland;
in {
  options.${moduleNameSpace}.hyprland = {
    enable = mkEnableOption "User hyprland";
    autoEnter = mkEnableOption "Auto enter hyprland after login";
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      plugins = with pkgs.hyprlandPlugins; [
        hyprexpo
	hyprspace
	hyprtrails
      ];
      settings = {
        "$terminal" = "wezterm";
        "$fileManager" = "nautilus";
        "$menu" = "wofi --show drun";
        "$mod" = "SUPER";
        exec-once = "waybar &";
        general = {
          gaps_in = 3;
          gaps_out = 16;

          border_size = 2;

          # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
          "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
          "col.inactive_border" = "rgba(595959aa)";

          # Set to true enable resizing windows by clicking and dragging on borders and gaps
          resize_on_border = true;

          # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
          allow_tearing = false;

          layout = "dwindle";

        };
        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };
        master = {
          new_status = "master";
        };
        bindm = [
          # Move/resize windows with mod + LMB/RMB and dragging
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];
        # FIXME: Don't know how to configure this.
        bindl = [
          # Requires playerctl
          ",XF86AudioNext, exec, playerctl next"
          ",XF86AudioPause, exec, playerctl play-pause"
          ",XF86AudioPlay, exec, playerctl play-pause"
          ",XF86AudioPrev, exec, playerctl previous"
        ];
        # FIXME: Don't know how to configure this.
        bindel = [
          # Laptop multimedia keys for volume and LCD brightness
          ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
          ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
          ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
          ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
        ];
        bind = [
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
          # Scroll through existing workspaces with mod + scroll
          "$mod, mouse_down, workspace, e+1"
          "$mod, mouse_up, workspace, e-1"
          # Example special workspace (scratchpad)
          "$mod, S, togglespecialworkspace, magic"
          "$mod SHIFT, S, movetoworkspace, special:magic"
        ] ++ (
          # workspaces
          # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
          builtins.concatLists (builtins.genList (i:
              let ws = i;
              in [
                "$mod, ${toString i}, workspace, ${toString ws}"
                "$mod SHIFT, ${toString i}, movetoworkspace, ${toString ws}"
              ]
            )
            10)
        );
        # TODO: Modules monitor
        monitor = "eDP-1, 1920x1080@60, 0x0, 1";

        # env = {
        #   XCURSOR_SIZE = 24;
        #   HYPRCURSOR_SIZE = 24;
        # 	# TODO: Modules gpucard
        #   AQ_DRM_DEVICES = "/dev/dri/card1";
        # };

        gestures = {
          workspace_swipe = true;
        };
        animations = {
          enabled = true;
          bezier = [
            "easein,0.1, 0, 0.5, 0"
            "easeinback,0.35, 0, 0.95, -0.3"

            "easeout,0.5, 1, 0.9, 1"
            "easeoutback,0.35, 1.35, 0.65, 1"

            "easeinout,0.45, 0, 0.55, 1"
          ];

          animation = [
            "fadeIn,1,3,easeout"
            "fadeLayersIn,1,3,easeoutback"
            "layersIn,1,3,easeoutback,slide"
            "windowsIn,1,3,easeoutback,slide"

            "fadeLayersOut,1,3,easeinback"
            "fadeOut,1,3,easein"
            "layersOut,1,3,easeinback,slide"
            "windowsOut,1,3,easeinback,slide"

            "border,1,3,easeout"
            "fadeDim,1,3,easeinout"
            "fadeShadow,1,3,easeinout"
            "fadeSwitch,1,3,easeinout"
            "windowsMove,1,3,easeoutback"
            "workspaces,1,2.6,easeoutback,slide"
          ];
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
          kb_options = "ctrl:swapcaps";
          # touchpad = {
          #   natural_scoll = true;
          # };
        };
      };
    };
    home.packages = with pkgs; [
      hyprshot
    ];
    programs= {
      hyprlock.enable = true;
      bash = mkIf cfg.autoEnter {
      enable = true;
      # NOTE: Start Hyprland after login
      profileExtra = ''
        if uwsm check may-start; then
            exec systemd-cat -t uwsm_start uwsm start default
        fi
      '';
      };
    };
  };


}
