-- https://github.com/neur1n/dotfiles/blob/59e5d86b01771c0c5ffad102c9758fcda2b6bc2c/wezterm/.wezterm/n_snippet.lua

local wezterm = require("wezterm")

local Pane = require("n_pane")

local M = {}

local function load(path)
  local f = io.open(path, "r")
  if f == nil then
    return {}
  end

  local json = wezterm.json_parse(f:read("a"))
  f:close()

  local list = {}
  local i = 1

  for k, v in pairs(json) do
    local item = {}
    item["label"] = k
    item["id"] = v
    list[i] = item
    i = i + 1
  end

  return list
end

function M.select(pane)
  local file = wezterm.config_dir .. "/.wezterm/snippet_vault.json"
  local list = load(path)

  return wezterm.action.InputSelector({
    title = "Snippets",
    choices = list,
    action = wezterm.action_callback(function(window, pane, id, label)
      local snippet = wezterm.json_parse(id)
      print(snippet)

      local cmd = ""
      local ms = 0

      for _, e in ipairs(snippet.event) do
        cmd, ms = next(e)
        pane:send_text(cmd .. "\r")
        wezterm.sleep_ms(ms)
      end
    end),
  })
end

return M
