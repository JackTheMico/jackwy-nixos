local wezterm = require("wezterm")

local config = {
  color_scheme = "Catppuccin Macchiato",
  font = wezterm.font("Maple Mono NF", { weight="Bold", italic=false }),
  font_size = 16,
  hide_tab_bar_if_only_one_tab = true,
  use_fancy_tab_bar = true,
  tab_bar_at_bottom = true,
  -- window_decorations = "RESIZE",
  show_new_tab_button_in_tab_bar = false,
  window_background_opacity = 0.9,
  text_background_opacity = 0.9,
  adjust_window_size_when_changing_font_size = true,
  enable_wayland = true,
  enable_scroll_bar = true,
  window_padding = {
    top = 2,
    right = 2,
    left = 2,
    bottom = 0,
  },
}


return config
