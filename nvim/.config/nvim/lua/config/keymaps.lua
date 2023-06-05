-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = function(mode, key, cmd, opts)
  vim.keymap.set(mode, key, cmd, opts or { silent = true })
end

map("i", "jk", "<ESC>")

if vim.fn.executable("gitui") == 1 then
  -- gitui instead of lazygit
  map("n", "<leader>gg", function()
    require("lazyvim.util").float_term({ "gitui" })
  end, { desc = "gitui (cwd)" })
  map("n", "<leader>gG", function()
    require("lazyvim.util").float_term({ "gitui" }, { cwd = require("lazyvim.util").get_root() })
  end, { desc = "gitui (root dir)" })
end

-- vim: foldmethod=marker foldlevel=0
