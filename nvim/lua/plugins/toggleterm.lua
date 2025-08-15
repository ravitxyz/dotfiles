return {
  'akinsho/toggleterm.nvim',
  version = "*",
  config = function()
    require("toggleterm").setup {
      size = 20,
      open_mapping = [[<c-t>]],
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      persist_size = true,  -- Persist terminal size
      persist_mode = true,  -- Persist terminal mode
      direction = "float",
      close_on_exit = false,  -- Keep terminal alive after process exits
      shell = vim.o.shell,
      float_opts = {
        border = "curved",
        winblend = 0,
        width = function()
          return math.floor(vim.o.columns * 0.8)
        end,
        height = function()
          return math.floor(vim.o.lines * 0.8)
        end,
        highlights = {
          border = "Normal",
          background = "Normal",
        },
      },
    }

    -- Create a persistent floating terminal
    local Terminal = require('toggleterm.terminal').Terminal
    local float_term = Terminal:new({
      direction = "float",
      float_opts = {
        border = "curved",
        width = function()
          return math.floor(vim.o.columns * 0.8)
        end,
        height = function()
          return math.floor(vim.o.lines * 0.8)
        end,
      },
      close_on_exit = false,
      start_in_insert = true,
    })

    -- Function to toggle the persistent floating terminal
    function _G.toggle_float_term()
      float_term:toggle()
    end

    -- Keymaps for persistent floating terminal
    vim.keymap.set('n', '<leader>tf', '<cmd>lua toggle_float_term()<CR>', { desc = "Toggle floating terminal" })
    vim.keymap.set('t', '<leader>tf', '<cmd>lua toggle_float_term()<CR>', { desc = "Toggle floating terminal" })
    
    -- Terminal mode keymaps for easier navigation
    vim.keymap.set('t', '<C-h>', '<C-\\><C-N><C-w>h', { desc = "Terminal left window nav" })
    vim.keymap.set('t', '<C-j>', '<C-\\><C-N><C-w>j', { desc = "Terminal down window nav" })
    vim.keymap.set('t', '<C-k>', '<C-\\><C-N><C-w>k', { desc = "Terminal up window nav" })
    vim.keymap.set('t', '<C-l>', '<C-\\><C-N><C-w>l', { desc = "Terminal right window nav" })
    vim.keymap.set('t', '<C-\\>', '<C-\\><C-n>', { desc = "Terminal normal mode" })
  end,
}
