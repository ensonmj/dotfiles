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
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
  config.default_prog = { "wsl.exe" }
end

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

-- Tab bar
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

-- Keys
-- config.disable_default_key_binding = true
-- config.use_dead_keys = false -- Allow using ^ with single key press.
config.leader = { key="a", mods="CTRL" }
config.keys = require("keys")

-- Mouse
config.mouse_bindings = require("mouse")

-- and finally, return the configuration to wezterm
return config
