-- space bar as leader key
vim.g.mapleader = " "

-- bufers
vim.keymap.set('n', '<leader>p', ':bp<cr>')
vim.keymap.set('n', '<leader>n', ':bn<cr>')
vim.keymap.set('n', '<leader>x', ':bd<cr>')
vim.keymap.set('n', '<leader>q', ':q<cr>')
vim.keymap.set('n', '<leader>Q', ':qa<cr>')

--- Remaps from theprimeagen
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "<A-J>", ":m .+1<CR>==")
vim.keymap.set("n", "<A-K>", ":m .-2<CR>==")

vim.keymap.set("n", "<A-o>", "o<Esc>")
vim.keymap.set("n", "<A-O>", "O<Esc>")

vim.keymap.set("n", "J", "mzJ`z")

vim.keymap.set("n", "<C-n>", "<C-d>zz")
vim.keymap.set("n", "<C-p>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])


-- Copy to clipboard
vim.keymap.set('v', '<leader>y', '"+y', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>Y', '"+yg_', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>y', '"+y', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>yy', '"+yy', { noremap = true, silent = true })

-- Paste from clipboard
vim.keymap.set('n', '<leader>p', '"+p', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>P', '"+P', { noremap = true, silent = true })
vim.keymap.set('v', '<leader>p', '"+p', { noremap = true, silent = true })
vim.keymap.set('v', '<leader>P', '"+P', { noremap = true, silent = true })

-- Map Ctrl+W and Ctrl+H in insert mode to delete the word before the cursor
-- This uses Neovim's native word deletion in insert mode
vim.api.nvim_set_keymap('i', '<C-w>', '<C-w>', {noremap = true})
vim.api.nvim_set_keymap('i', '<C-h>', '<C-w>', {noremap = true})

-- Ergonomic fold commands
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<Tab>", "za", opts) -- toggle fold
vim.keymap.set("n", "<S-Tab>", "zA", opts) -- toggle fold recursively  
vim.keymap.set("n", "<leader>fo", "zR", opts) -- open all folds
vim.keymap.set("n", "<leader>fc", "zM", opts) -- close all folds
vim.keymap.set("n", "<leader>fr", function() -- refresh folds
  vim.cmd("set foldmethod=expr")
  vim.cmd("set foldexpr=v:lua.vim.lsp.foldexpr()")
  vim.cmd("normal! zx") -- Force fold refresh
  print("Refreshed LSP folds")
end, { desc = "Refresh LSP folds", noremap = true, silent = true })

-- NeoTree
vim.keymap.set("n", "<leader>e", ":Neotree toggle float<CR>", opts) -- floating file explorer

-- Debugging syntax highlighting and LSP
vim.keymap.set("n", "<leader>dh", function()
  -- Restart syntax highlighting
  vim.cmd("syntax off")
  vim.cmd("syntax on")
  -- Restart treesitter highlighting
  if pcall(require, "nvim-treesitter.highlight") then
    vim.cmd("TSBufToggle highlight")
    vim.cmd("TSBufToggle highlight")
  end
  print("Syntax highlighting restarted")
end, { desc = "Restart syntax highlighting", noremap = true, silent = true })

vim.keymap.set("n", "<leader>dl", function()
  vim.cmd("LspRestart")
  print("LSP restarted")
end, { desc = "Restart LSP", noremap = true, silent = true })

vim.keymap.set("n", "<leader>dt", function()
  if pcall(require, "nvim-treesitter.highlight") then
    vim.cmd("TSToggle highlight")
    print("Treesitter highlighting toggled")
  else
    print("Treesitter not available")
  end
end, { desc = "Toggle treesitter highlighting", noremap = true, silent = true })

vim.keymap.set("n", "<leader>ds", function()
  -- Show syntax info at cursor
  local hi_group = vim.fn.synIDattr(vim.fn.synID(vim.fn.line("."), vim.fn.col("."), 1), "name")
  local ts_hi = vim.treesitter.get_captures_at_cursor(0)
  
  print("Syntax group: " .. hi_group)
  if #ts_hi > 0 then
    print("Treesitter: " .. table.concat(ts_hi, ", "))
  else
    print("No treesitter highlighting")
  end
end, { desc = "Show syntax info", noremap = true, silent = true })

vim.keymap.set("n", "<leader>dx", function()
  -- Stop all TypeScript servers except typescript-tools
  local clients = vim.lsp.get_clients()
  local stopped = {}
  local typescript_tools_found = false
  
  for _, client in ipairs(clients) do
    if client.name == "typescript-tools" then
      typescript_tools_found = true
    elseif string.match(client.name:lower(), "typescript") or 
           string.match(client.name:lower(), "ts_ls") or 
           client.name == "tsserver" then
      vim.lsp.stop_client(client.id)
      table.insert(stopped, client.name)
    end
  end
  
  -- Show all current clients for debugging
  local all_clients = {}
  for _, client in ipairs(vim.lsp.get_clients()) do
    table.insert(all_clients, client.name)
  end
  print("All LSP clients: " .. table.concat(all_clients, ", "))
  
  if #stopped > 0 then
    print("Stopped conflicting servers: " .. table.concat(stopped, ", "))
    -- Small delay to ensure servers are stopped
    vim.defer_fn(function()
      if typescript_tools_found then
        vim.cmd("LspRestart typescript-tools")
        print("Restarted typescript-tools")
      end
    end, 500)
  else
    print("No conflicting TypeScript servers found")
  end
end, { desc = "Fix duplicate TypeScript servers", noremap = true, silent = true })

vim.keymap.set("n", "<leader>sw", function()
  -- Clean up swap files and recover from swap file issues
  vim.cmd("silent! %bdelete") -- Close all buffers
  vim.cmd("silent! wall")     -- Write all files
  -- Clear any swap files that might be lingering
  local swap_dir = vim.fn.stdpath("data") .. "/swap"
  vim.fn.system("rm -rf " .. swap_dir .. "/*")
  print("Cleaned up swap files")
end, { desc = "Clean swap files", noremap = true, silent = true })

vim.keymap.set("n", "<leader>dm", function()
  -- Open Mason and show installed packages
  vim.cmd("Mason")
end, { desc = "Open Mason package manager", noremap = true, silent = true })

-- Close quickfix and location list windows
vim.keymap.set("n", "<leader>cc", function()
  vim.cmd("cclose") -- Close quickfix
  vim.cmd("lclose") -- Close location list
  print("Closed quickfix and location list")
end, { desc = "Close quickfix and location list", noremap = true, silent = true })

-- Clear search highlighting with Escape
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlighting", noremap = true, silent = true })

