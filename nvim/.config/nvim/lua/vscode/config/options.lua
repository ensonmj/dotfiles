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

-- vim: foldmethod=marker foldlevel=0
