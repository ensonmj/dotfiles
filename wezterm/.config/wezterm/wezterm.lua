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
config.font = wezterm.font_with_fallback({ "Sarasa Term SC Nerd Font", monospace })
config.font_size = 11
-- config.line_height = 0.9
-- config.cell_width = 0.9
config.scrollback_lines = 99999
config.launch_menu = require("launch_menu")

-- Window
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.96 -- 如果设置为1.0会明显卡顿
config.text_background_opacity = 1.0
-- config.window_padding = {
--     left = 0,
--     right = 0,
--     top = 0,
--     bottom = 0,
-- }

-- Tab bar
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.colors = {
  tab_bar = {
    -- The color of the strip that goes along the top of the window
    background = "#222222",

    -- The active tab is the one that has focus in the window
    active_tab = {
      bg_color = "#DFCA88",
      fg_color = "#274642",

      -- Specify whether you want "Half", "Normal" or "Bold" intensity for the
      -- label shown for this tab.
      -- The default is "Normal"
      intensity = "Bold",
    },

    -- Inactive tabs are the tabs that do not have focus
    inactive_tab = {
      bg_color = "#222222",
      fg_color = "#808080",
    },

    -- You can configure some alternate styling when the mouse pointer
    -- moves over inactive tabs
    inactive_tab_hover = {
      bg_color = "#EEE8D5",
      fg_color = "#909090",
      italic = false,
    },
  },
}

-- Keys
-- config.disable_default_key_binding = true
config.use_dead_keys = false -- Allow using ^ with single key press.
config.leader = { key = "a", mods = "CTRL" }
config.keys = require("keys")

-- Mouse
config.mouse_bindings = require("mouse")

-- and finally, return the configuration to wezterm
return config
