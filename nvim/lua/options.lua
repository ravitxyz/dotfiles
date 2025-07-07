vim.opt.nu = true -- enable line numbers
vim.opt.relativenumber = true -- enable relative live numbers
-- vim.opt.cursorline = true -- highlight the current line
vim.opt.colorcolumn = "80" -- highlight column at 80 characters

vim.o.tabstop = 4 -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 4 -- Number of spaces inserted when indenting

vim.opt.clipboard = 'unnamedplus'
vim.opt.cmdheight=0


-- Configure LSP-based folding for better language support
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.lsp.foldexpr()"
vim.opt.foldcolumn = "1"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true
