return {
  "nvim-lualine/lualine.nvim",
  dependencies = { 
    "nvim-tree/nvim-web-devicons",
    "rose-pine/neovim" 
  },
  config = function()
    local lualine = require("lualine")

    lualine.setup({
      options = {
        theme = "rose-pine",
        globalstatus = true,
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
      },
      sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff', 'diagnostics'},
        lualine_c = {
          {
            'filename',
            path = 0, -- Only show filename, no path
            symbols = {
              modified = '●', -- Text to show when the file is modified
              readonly = '🔒', -- Text to show when the file is non-modifiable or readonly
              unnamed = '[No Name]', -- Text to show for unnamed buffers
              newfile = '[New]', -- Text to show for newly created file before first write
            }
          }
        },
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {'neo-tree'}
    })
  end,
}
