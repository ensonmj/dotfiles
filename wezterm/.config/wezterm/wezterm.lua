-- Pull in the wezterm API
local wezterm = require("wezterm")

-- use the config_builder which will help provide clearer error messages
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
config.color_scheme = "Dracula (Official)"
config.colors = {
  selection_bg = "#FCE8C3",
  selection_fg = "#121212",
}

-- config.line_height = 1.1
-- config.cell_width = 0.9
config.font_size = 11
-- https://wezfurlong.org/wezterm/config/lua/wezterm/font_with_fallback.html#manual-fallback-scaling
config.font = wezterm.font({ family = "Sarasa Term SC Nerd Font", scale = 1.2 })
config.warn_about_missing_glyphs = false
-- config.freetype_load_flags = "NO_HINTING"
config.freetype_load_target = "Light"
config.freetype_render_target = "HorizontalLcd"
config.foreground_text_hsb = {
  hue = 1.0,
  saturation = 1.0,
  brightness = 0.9, -- default is 1.0
}
config.initial_rows = 40
config.initial_cols = 120
config.scrollback_lines = 99999
config.exit_behavior = "Close"

-- Window
-- Integrated Title Bar
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.enable_scroll_bar = true
config.window_background_opacity = 0.94 -- 如果设置为1.0会明显卡顿
config.text_background_opacity = 1.0
config.window_padding = {
  left = 5,
  right = 5,
  top = 5,
  bottom = 5,
}

-- Tab bar
config.use_fancy_tab_bar = false
-- config.tab_bar_at_bottom = true
-- config.hide_tab_bar_if_only_one_tab = true
config.tab_max_width = 20
config.tab_bar_style = {
  window_hide = " - ",
  window_hide_hover = " - ",
  window_maximize = " + ",
  window_maximize_hover = " + ",
  window_close = " x ",
  window_close_hover = " x ",
}

-- Events
require("events")
-- Keys
require("keys").setup(config)
-- Mouse
require("mouse").setup(config)
-- Launch Menu
require("launch_menu").setup(config)
-- ssh/unix domains
require("domains").setup(config)
-- OS platform specific
require("platform").setup(config)

-- and finally, return the configuration to wezterm
return config
