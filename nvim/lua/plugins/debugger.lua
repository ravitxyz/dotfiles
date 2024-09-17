return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "mfussenegger/nvim-dap-python",
    },
    config = function()
      local dap = require('dap')
      local dap_python = require('dap-python')

      -- Enhanced function to find the Python executable in the Poetry environment
      local function get_poetry_python_path()
        -- ... (rest of your get_poetry_python_path function)
      end

      -- Set up nvim-dap-python with the Poetry Python path
      dap_python.setup(get_poetry_python_path())

      -- Automatically use Poetry environment for debugging sessions
      dap_python.resolve_python = function()
        return get_poetry_python_path()
      end

      -- Configure Python adapter
      dap.configurations.python = {
        -- ... (rest of your dap configurations)
      }

      -- Keymappings
      vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = 'Toggle Breakpoint' })
      vim.keymap.set('n', '<leader>dc', dap.continue, { desc = 'Start/Continue Debugging' })
      vim.keymap.set('n', '<leader>di', dap.step_into, { desc = 'Step Into' })
      vim.keymap.set('n', '<leader>do', dap.step_over, { desc = 'Step Over' })

      -- Optional: Add a custom command to update the Python path
      vim.api.nvim_create_user_command('UpdatePythonPath', function()
        local new_path = get_poetry_python_path()
        dap_python.setup(new_path)
        print("Updated Python path to: " .. new_path)
      end, {})

      -- Function to detect if we're in a Poetry project
      local function is_poetry_project()
        return vim.fn.filereadable('pyproject.toml') == 1
      end

      -- Auto-command to set up Python debugging when entering a Python file
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "python",
        callback = function()
          if is_poetry_project() then
            local python_path = get_poetry_python_path()
            dap_python.setup(python_path)
            print("Set up Python debugging with Poetry: " .. python_path)
          end
        end
      })
    end,
  }
}
