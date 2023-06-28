-- autocmd
local autocmd = vim.api.nvim_create_autocmd
local function augroup(name)
  return vim.api.nvim_create_augroup("dotconfig_" .. name, { clear = true })
end

-- override some options
autocmd("VimEnter", {
  group = augroup("vscode_override"),
  callback = function()
    -- relativenumber will corrupt vscode search highlight
    vim.o.relativenumber = false
    vim.o.cursorcolumn = false
    vim.o.virtualedit = "block"
  end,
})

-- keymaps
local map = function(mode, key, cmd, opts)
  vim.api.nvim_set_keymap(mode, key, cmd, opts or { noremap = true, silent = true })
end

map("n", "Q", "<Nop>")
map("n", "q:", "<Nop>")
map("n", "<C-c>", "<Esc>")
map("n", "Y", "y$")
map("n", "<CR>", '{->v:hlsearch ? ":nohl\\<CR>" : "\\<CR>"}()', { expr = true })
map("n", "x", '"_x')
map("n", "X", '"_X')

-- Better navigation
map("n", "<C-j>", '<cmd>call VSCodeNotify("workbench.action.navigateDown")<CR>')
map("n", "<C-k>", '<cmd>call VSCodeNotify("workbench.action.navigateUp")<CR>')
map("n", "<C-h>", '<cmd>call VSCodeNotify("workbench.action.navigateLeft")<CR>')
map("n", "<C-l>", '<cmd>call VSCodeNotify("workbench.action.navigateRight")<CR>')

map("x", "<", "<gv")
map("x", ">", ">gv")
map("x", "K", ":move '<-2<CR>gv-gv")
map("x", "J", ":move '>+1<CR>gv-gv")

-- Commentary
map("x", "gc", "<Plug>VSCodeCommentary", { noremap = false })
map("n", "gc", "<Plug>VSCodeCommentary", { noremap = false })
map("o", "gc", "<Plug>VSCodeCommentary", { noremap = false })
map("n", "gcc", "<Plug>VSCodeCommentaryLine", { noremap = false })

-- vim: foldmethod=marker foldlevel=0
