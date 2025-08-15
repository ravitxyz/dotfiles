vim.opt.nu = true -- enable absolute line numbers
vim.opt.relativenumber = true -- enable relative line numbers (creates hybrid mode)

-- Ensure consistent line number settings across all buffers
vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter", "BufReadPost", "FileReadPost"}, {
  pattern = "*",
  callback = function(ev)
    -- Skip special buffer types that shouldn't have line numbers
    local buf_type = vim.api.nvim_get_option_value("buftype", { buf = ev.buf })
    local file_type = vim.api.nvim_get_option_value("filetype", { buf = ev.buf })
    
    if buf_type == "" and file_type ~= "qf" and file_type ~= "help" then
      -- All window-local options
      vim.api.nvim_set_option_value("number", true, { win = 0 })
      vim.api.nvim_set_option_value("relativenumber", true, { win = 0 })
      vim.api.nvim_set_option_value("signcolumn", "yes:1", { win = 0 })
    end
  end,
  desc = "Force consistent hybrid line numbers in regular buffers"
})
-- vim.opt.cursorline = true -- highlight the current line
vim.opt.colorcolumn = "80" -- highlight column at 80 characters

vim.o.tabstop = 4 -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 4 -- Number of spaces inserted when indenting

vim.opt.clipboard = 'unnamedplus'
vim.opt.cmdheight=0


-- LSP-based folding for better language support
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.lsp.foldexpr()"
vim.opt.foldcolumn = "0"        -- Hide fold column (no extra number column)
vim.opt.foldlevel = 99          -- Open all folds by default  
vim.opt.foldlevelstart = 99     -- Start with all folds open
vim.opt.foldenable = true       -- Enable folding
vim.opt.fillchars = { fold = " " } -- Clean fold appearance

-- Better swap file handling
vim.opt.swapfile = false -- Disable swap files to avoid conflicts
vim.opt.backup = false   -- Disable backup files  
vim.opt.writebackup = false -- Disable backup before overwriting
vim.opt.undofile = true  -- Enable persistent undo instead
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"
