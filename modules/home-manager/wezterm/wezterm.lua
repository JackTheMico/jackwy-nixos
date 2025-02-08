local wezterm = require("wezterm")
local config = {
  color_scheme = "catppuccin Macchiate",
  font = wezterm.font("Maple Mono NF", { weight="Bold", italic=false }),
  hide_tab_bar_if_only_one_tab = true,
  use_fancy_tab_bar = false,
  window_decorations = "RESIZE",
  show_new_tab_button_in_tab_bar = false,
  window_background_opacity = 0.9,
  text_background_opacity = 0.9,
  adjust_window_size_when_changing_font_size = false,
}


return config
