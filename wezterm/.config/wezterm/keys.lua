local wezterm = require("wezterm")
local act = wezterm.action

return {
  leader = { key = "a", mods = "CTRL" },
  keys = {
    -- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
    { key = "a", mods = "LEADER|CTRL", action = act.SendString("\x01") },
    { key = "Enter", mods = "ALT", action = act.ToggleFullScreen },
    { key = "p", mods = "SHIFT|CTRL", action = act.ActivateCommandPalette },
    { key = "d", mods = "SHIFT|CTRL", action = act.ShowDebugOverlay },
    { key = "l", mods = "SHIFT|CTRL", action = act.ShowLauncher },
    { key = "=", mods = "CTRL", action = act.ResetFontSize },
    { key = "+", mods = "SHIFT|CTRL", action = act.IncreaseFontSize },
    { key = "-", mods = "CTRL", action = act.DecreaseFontSize },

    { key = "-", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
    { key = "\\", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
    { key = "t", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
    { key = "T", mods = "LEADER|SHIFT", action = act.CloseCurrentTab({ confirm = true }) },
    { key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
    { key = "f", mods = "LEADER", action = act.Search("CurrentSelectionOrEmptyString") },
    { key = "c", mods = "LEADER", action = act.ActivateCopyMode },
    { key = "v", mods = "LEADER", action = act.PasteFrom("Clipboard") },
    { key = "phys:Space", mods = "LEADER", action = act.QuickSelect },

    { key = "1", mods = "LEADER", action = act.ActivateTab(0) },
    { key = "2", mods = "LEADER", action = act.ActivateTab(1) },
    { key = "3", mods = "LEADER", action = act.ActivateTab(2) },
    { key = "4", mods = "LEADER", action = act.ActivateTab(3) },
    { key = "5", mods = "LEADER", action = act.ActivateTab(4) },
    { key = "6", mods = "LEADER", action = act.ActivateTab(5) },
    { key = "7", mods = "LEADER", action = act.ActivateTab(6) },
    { key = "8", mods = "LEADER", action = act.ActivateTab(7) },
    { key = "9", mods = "LEADER", action = act.ActivateTab(-1) },

    -- LEADER, followed by 'r' will put us in resize-pane
    -- mode until we cancel that mode.
    {
      key = "r",
      mods = "LEADER",
      action = act.ActivateKeyTable({
        name = "resize_pane",
        one_shot = false,
      }),
    },

    -- LEADER, followed by 'w' will put us in activate-pane
    -- mode until we press some other key or until 1 second (1000ms)
    -- of time elapses
    {
      key = "w",
      mods = "LEADER",
      action = act.ActivateKeyTable({
        name = "activate_pane",
        timeout_milliseconds = 1000,
      }),
    },
  },
  key_tables = {
    -- Defines the keys that are active in our resize-pane mode.
    -- Since we're likely to want to make multiple adjustments,
    -- we made the activation one_shot=false. We therefore need
    -- to define a key assignment for getting out of this mode.
    -- 'resize_pane' here corresponds to the name="resize_pane" in
    -- the key assignments above.
    resize_pane = {
      { key = "LeftArrow", action = act.AdjustPaneSize({ "Left", 1 }) },
      { key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },

      { key = "RightArrow", action = act.AdjustPaneSize({ "Right", 1 }) },
      { key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },

      { key = "UpArrow", action = act.AdjustPaneSize({ "Up", 1 }) },
      { key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },

      { key = "DownArrow", action = act.AdjustPaneSize({ "Down", 1 }) },
      { key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },

      -- Cancel the mode by pressing escape
      { key = "Escape", action = "PopKeyTable" },
    },

    -- Defines the keys that are active in our activate-pane mode.
    -- 'activate_pane' here corresponds to the name="activate_pane" in
    -- the key assignments above.
    activate_pane = {
      { key = "LeftArrow", action = act.ActivatePaneDirection("Left") },
      { key = "h", action = act.ActivatePaneDirection("Left") },

      { key = "RightArrow", action = act.ActivatePaneDirection("Right") },
      { key = "l", action = act.ActivatePaneDirection("Right") },

      { key = "UpArrow", action = act.ActivatePaneDirection("Up") },
      { key = "k", action = act.ActivatePaneDirection("Up") },

      { key = "DownArrow", action = act.ActivatePaneDirection("Down") },
      { key = "j", action = act.ActivatePaneDirection("Down") },
    },
  },
}
