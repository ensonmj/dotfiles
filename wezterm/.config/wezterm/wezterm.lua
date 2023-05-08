-- Pull in the wezterm API
local wezterm = require("wezterm")
require("events")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices
config.color_scheme = "Dracula (Official)"
config.font = wezterm.font_with_fallback({ "FiraMono Nerd Font Mono", "monospace", monospace })
config.font_size = 11 
-- config.line_height = 0.9
-- config.cell_width = 0.9
config.scrollback_lines = 99999
config.launch_menu = require("launch_menu")

-- Window
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.98 -- 如果设置为1.0会明显卡顿
config.window_background_image_hsb = {
  hue = 1.0,
  saturation = 1.0,
  brightness = 0.8,
}

-- Pane
config.inactive_pane_hsb = {
  hue = 1.0,
  saturation = 1.0,
  brightness = 1.0,
}

-- Tab bar
-- config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false

-- Keys
-- config.disable_default_key_bindings = false
-- Allow using ^ with single key press.
config.use_dead_keys = false
config.leader = { key="a", mods="CTRL" }
config.keys = require("keys")

-- Mouse
config.mouse_bindings = require("mouse")

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
  config.default_prog = { "wsl.exe" }
end

-- and finally, return the configuration to wezterm
return config
