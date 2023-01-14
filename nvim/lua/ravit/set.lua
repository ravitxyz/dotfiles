--vim.opt.guicursor = ""

-- line numbers
vim.opt.nu = true
vim.opt.relativenumber = true

-- tabs & indentation
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
--vim.oopt.autoindent = true
vim.opt.smartindent = true

-- search
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.smartcase = true

-- cursor line
vim.opt.cursorline = true
vim.opt.wrap = false

-- appearance
--vim.g.colors_name = "catpuccin"
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "79"
--backspace
vim.opt.backspace = "indent,eol,start"

--split windows
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.iskeyword:append("-")

-- turn off showmode with lualine
vim.opt.showmode = false

