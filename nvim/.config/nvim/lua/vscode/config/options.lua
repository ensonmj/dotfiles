local map = function(mode, key, cmd, opts)
  vim.api.nvim_set_keymap(mode, key, cmd, opts or { noremap = true, silent = true })
end

vim.opt.rtp:remove(vim.fn.stdpath("data") .. "/site")
vim.opt.rtp:remove(vim.fn.stdpath("data") .. "/site/after")
vim.cmd([[let &packpath = &runtimepath]])

-- Leader key
vim.g.mapleader = " "
vim.o.mouse = "a"

-- Search {{{
-- Ignore the case of normal letters.
vim.o.ignorecase = true
-- If the search pattern contains upper case characters, override ignorecase option.
vim.o.smartcase = true

-- Enable incremental search.
vim.o.incsearch = true
-- Enable highlight search result.
vim.o.hlsearch = true

-- Searches wrap around the end of the file.
vim.o.wrapscan = true
-- }}}

-- Edit {{{
vim.o.clipboard = "unnamedplus"
vim.o.virtualedit = "block"
-- vim.o.smarttab = true
-- vim.o.expandtab = true
-- vim.o.tabstop = 4
-- vim.o.softtabstop = 4
-- vim.o.autoindent = true
-- vim.o.smartindent = true
-- vim.o.cindent = true
-- vim.o.shiftwidth = 4

-- allow backspacing over everything in insert mode
-- vim.o.backspace = "indent,eol,start"

-- Highlight parenthesis.
-- vim.o.showmatch = true
-- vim.o.matchtime = 3

-- Set undofile
vim.o.undofile = true
vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false
-- vim.o.updatetime = 100

-- Set keyword help.
-- set keywordprg=:help
-- }}}

map("n", "Q", "<Nop>")
map("n", "q:", "<Nop>")
map("n", "<C-c>", "<Esc>")
map("n", "Y", "y$")
map("n", "<CR>", '{->v:hlsearch ? ":nohl\\<CR>" : "\\<CR>"}()', { expr = true })
map("n", "x", '"_x')
map("n", "X", '"_X')

map("x", "<", "<gv")
map("x", ">", ">gv")
map("x", "K", ":move '<-2<CR>gv-gv")
map("x", "J", ":move '>+1<CR>gv-gv")

-- Better navigation
map("n", "<C-j>", '<cmd>call VSCodeNotify("workbench.action.navigateDown")<CR>')
map("n", "<C-k>", '<cmd>call VSCodeNotify("workbench.action.navigateUp")<CR>')
map("n", "<C-h>", '<cmd>call VSCodeNotify("workbench.action.navigateLeft")<CR>')
map("n", "<C-l>", '<cmd>call VSCodeNotify("workbench.action.navigateRight")<CR>')

-- Commentary
map("x", "gc", "<Plug>VSCodeCommentary", { noremap = false })
map("n", "gc", "<Plug>VSCodeCommentary", { noremap = false })
map("o", "gc", "<Plug>VSCodeCommentary", { noremap = false })
map("n", "gcc", "<Plug>VSCodeCommentaryLine", { noremap = false })

-- vim: foldmethod=marker foldlevel=0
