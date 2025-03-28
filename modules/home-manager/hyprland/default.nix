{moduleNameSpace, ...}: {
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
with lib; let
  cfg = config.${moduleNameSpace}.hyprland;
in {
  options.${moduleNameSpace}.hyprland = {
    enable = mkEnableOption "User hyprland";
    autoEnter = mkEnableOption "Auto enter hyprland after login";
    monitor = mkOption {
      type = types.listOf types.str;
      description = "List of monitor settings: 'name, resolution, position, scale'";
      default = ["eDP-1, 1920x1080@60, 0x0, 1"];
    };
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      plugins = with pkgs.hyprlandPlugins; [hyprsplit];
      settings = {
        "$terminal" = "wezterm";
        "$fileManager" = "nautilus";
        "$menu" = "rofi -show drun";
        "$mod" = "SUPER";
        exec-once = ["waybar" "clash-verge" "clipse -listen" "fcitx5" "swww-daemon" "pypr"];
        plugin = {
          hyprsplit = {
            num_workspaces = 10;
            persistent_workspaces = false;
          };
        };
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
        master = {new_status = "master";};
        bindm = [
          # Move/resize windows with mod + LMB/RMB and dragging
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];
        bindl = [
          # Requires playerctl
          ",XF86AudioNext, exec, playerctl next"
          ",XF86AudioPause, exec, playerctl play-pause"
          ",XF86AudioPlay, exec, playerctl play-pause"
          ",XF86AudioPrev, exec, playerctl previous"
        ];
        bindel = [
          # Laptop multimedia keys for volume and LCD brightness
          ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
          ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
          ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
          ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
        ];
        bind =
          [
            # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
            "$mod, return, exec, $terminal"
            "$mod, Q, killactive"
            "$mod SHIFT, M, exit"
            "$mod, E, exec, $fileManager"
            "$mod, F, togglefloating"
            "$mod, R, exec, $menu"
            "$mod, P, pseudo, # dwindle"
            "$mod, J, togglesplit, # dwindle"
            "$mod, T, exec, pypr toggle wezterm"
            # Move focus with mod + arrow keys
            "$mod, left, movefocus, l"
            "$mod, right, movefocus, r"
            "$mod, up, movefocus, u"
            "$mod, down, movefocus, d"
            # Resize windows
            "$mod SHIFT, left, resizeactive, -10 0"
            "$mod SHIFT, right, resizeactive, 10 0"
            "$mod SHIFT, up, resizeactive, 0 -10"
            "$mod SHIFT, down, resizeactive, 0 10"
            # Scroll through existing workspaces with mod + scroll
            "$mod, mouse_down, workspace, e+1"
            "$mod, mouse_up, workspace, e-1"
            # Example special workspace (scratchpad)
            "$mod, S, togglespecialworkspace, magic"
            "$mod SHIFT, S, movetoworkspace, special:magic"
            "$mod, 0, split:workspace, 10"
            "$mod SHIFT, 0, split:movetoworkspace, 10"
            "$mod Alt, 0, split:movetoworkspacesilent, 10"
            # hyprsplit
            # "$mod, D, split:swapactiveworkspaces, current +1"
            "$mod, G, split:swapactiveworkspaces, current +1"
            # Clipse
            "$mod, V, exec, kitty --class clipse -e clipse"
            # hyprshot
            "$mod Shift, O, exec, hyprshot -m output -o ~/Pictures/hyprshot"
            "$mod Shift, W, exec, hyprshot -m window -o ~/Pictures/hyprshot"
            "$mod Shift, R, exec, hyprshot -m region -o ~/Pictures/hyprshot"
            "$mod Shift, C, exec, hyprshot -m region --clipboard-only"
          ]
          ++ (
            # workspaces
            # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
            builtins.concatLists (builtins.genList (i: let
                ws = i + 1;
              in [
                "$mod, ${toString (i + 1)}, split:workspace, ${toString ws}"
                "$mod SHIFT, ${toString (i + 1)}, split:movetoworkspace, ${toString ws}"
                "$mod Alt, ${toString (i + 1)}, split:movetoworkspacesilent, ${toString ws}"
              ])
              9)
          );
        monitor = cfg.monitor;
        env = [
          # Hint Electron apps to use Wayland
          "NIXOS_OZONE_WL,1"
          "XDG_CURRENT_DESKTOP,Hyprland"
          "XDG_SESSION_TYPE,wayland"
          "XDG_SESSION_DESKTOP,Hyprland"
          "QT_QPA_PLATFORM,wayland"
          "XDG_SCREENSHOTS_DIR,$HOME/screens"
          "ELECTRON_OZONE_PLATFORM_HINT,auto"
        ];
        windowrulev2 = let
          rulesForWindow = window: map (rule: "${rule},${window}");
        in
          []
          # General window rules
          ++ (rulesForWindow "floating:0" ["rounding 0"])
          ++ (rulesForWindow "floating:1" ["rounding 5"])
          ++ (rulesForWindow "floating:0" ["noshadow"])
          ++ (rulesForWindow "class:(clipse)" ["float" "size 622 652" "stayfocused"]);

        gestures = {workspace_swipe = true;};
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
          inactive_opacity = 0.9;

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
        };
      };
    };
    home.packages = with pkgs; [waybar hyprshot swww hypridle libnotify pyprland];
    programs = {
      hyprlock.enable = true;
      waybar = {enable = true;};
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
    services.hypridle.enable = true;
    xdg = {
      configFile = {
        "hypr/hypridle.conf".source = ./hypridle.conf;
        "hypr/pyprland.toml".source =
          config.lib.file.mkOutOfStoreSymlink ./pyprland.toml;
        "hypr/mocha.conf".source = "${inputs.catppuccin-hyprland}/themes/mocha.conf";
        "hypr/hyprlock.conf".source = "${inputs.catppuccin-hyprlock}/hyprlock.conf";
        "waybar/mocha.css".source = "${inputs.catppuccin-waybar}/themes/mocha.css";
        "waybar/config.jsonc".source =
          config.lib.file.mkOutOfStoreSymlink ./config.jsonc;
        "waybar/style.css".source =
          config.lib.file.mkOutOfStoreSymlink ./style.css;
      };
    };
  };
}
