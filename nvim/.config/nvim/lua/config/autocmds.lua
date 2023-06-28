-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
local autocmd = vim.api.nvim_create_autocmd
local function augroup(name)
  return vim.api.nvim_create_augroup("dotconfig_" .. name, { clear = true })
end

-- relativenumber will corrupt vscode search highlight
if not vim.g.vscode then
  local relativenumber_toggle_group = augroup("relativenumber_toggle")
  autocmd({ "BufEnter", "FocusGained", "InsertLeave" }, {
    desc = "toggles relativenumber on and off based on mode",
    group = relativenumber_toggle_group,
    command = "set relativenumber",
  })
  autocmd({ "BufLeave", "FocusLost", "InsertEnter" }, {
    desc = "toggles relativenumber on and off based on mode",
    group = relativenumber_toggle_group,
    command = "set norelativenumber",
  })
end

autocmd("BufEnter", {
  desc = "fix auto comment",
  command = "set fo-=c fo-=r fo-=o",
})

autocmd({ "VimResized" }, {
  desc = "resize splits if window resized",
  command = "tabdo wincmd =",
})

local cursor_line_group = augroup("cursor_line")
autocmd({ "InsertLeave", "WinEnter" }, {
  desc = "show cursor line only in active window",
  group = cursor_line_group,
  callback = function()
    local ok, cl = pcall(vim.api.nvim_win_get_var, 0, "auto-cursorline")
    if ok and cl then
      vim.wo.cursorline = true
      vim.api.nvim_win_del_var(0, "auto-cursorline")
    end
  end,
})
autocmd({ "InsertEnter", "WinLeave" }, {
  desc = "show cursor line only in active window",
  group = cursor_line_group,
  callback = function()
    local cl = vim.wo.cursorline
    if cl then
      vim.api.nvim_win_set_var(0, "auto-cursorline", cl)
      vim.wo.cursorline = false
    end
  end,
})

autocmd("BufWritePre", {
  desc = "create directories when needed, when saving a file",
  group = augroup("better_backup"),
  callback = function(event)
    local file = vim.loop.fs_realpath(event.match) or event.match
    local backup = vim.fn.fnamemodify(file, ":p:~:h")
    backup = backup:gsub("[/\\]", "%%")
    vim.go.backupext = backup
  end,
})

autocmd({ "FileType" }, {
  desc = "fix conceallevel for json & help files",
  pattern = { "json", "jsonc" },
  callback = function()
    vim.wo.spell = false
    vim.wo.conceallevel = 0
  end,
})

local quit_group = augroup("quit")
autocmd("FileType", {
  desc = "close some filetypes with <q>",
  group = quit_group,
  pattern = { "dap-float", "httpResult" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

autocmd("FileType", {
  desc = "close some filetypes with <q>",
  group = quit_group,
  pattern = { "dap-terminal" },
  callback = function(event)
    vim.keymap.set("n", "q", "<cmd>bdelete!<cr>", { buffer = event.buf, silent = true })
  end,
})

-- filetype
autocmd("FileType", {
  pattern = { "cc", "cpp" },
  command = [[setlocal cms=//\ %s]],
})
-- vim.cmd([[
--   autocmd FileType NvimTree setlocal tabstop=2 shiftwidth=2 softtabstop=2 textwidth=0
--
--   autocmd FileType lua setlocal tabstop=4 shiftwidth=4 softtabstop=4
--   autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4 textwidth=120
--   autocmd FileType json,jsonnet setlocal tabstop=2 shiftwidth=2 softtabstop=2
--   autocmd FileType go setlocal tabstop=4 shiftwidth=4 softtabstop=4
--   autocmd FileType html,htmldjango,xhtml,haml setlocal tabstop=2 shiftwidth=2 softtabstop=2 textwidth=0
--   autocmd FileType yaml setlocal tabstop=2 shiftwidth=2 softtabstop=2 textwidth=0
--   autocmd FileType less,sass,scss,css setlocal tabstop=2 shiftwidth=2 softtabstop=2
--   autocmd FileType javascript,javascript.jsx,typescript setlocal tabstop=2 shiftwidth=2 softtabstop=2
--
--   autocmd BufNewFile,BufRead *.proto setfiletype proto
--   autocmd FileType proto setlocal shiftwidth=4
-- ]])

-- vim: foldmethod=marker foldlevel=0
