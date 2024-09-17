local dap = require('dap')
local dap_python = require('dap-python')

-- Enhanced function to find the Python executable in the Poetry environment
local function get_poetry_python_path()
  -- Try to get the path from Poetry
  local poetry_output = vim.fn.system('poetry env info -p')
  if vim.v.shell_error == 0 then
    local poetry_venv = vim.fn.trim(poetry_output)
    if poetry_venv ~= "" then
      return poetry_venv .. '/bin/python'
    end
  end
  
  -- If Poetry environment is not found, try to find a local virtual environment
  local venv_path = vim.fn.finddir('venv', vim.fn.getcwd() .. ';')
  if venv_path ~= "" then
    return vim.fn.fnamemodify(venv_path, ':p') .. 'bin/python'
  end
  
  -- Fallback to system Python if no virtual environment is found
  return vim.fn.exepath('python3') or vim.fn.exepath('python') or 'python'
end

-- Set up nvim-dap-python with the Poetry Python path
dap_python.setup(get_poetry_python_path())

-- Automatically use Poetry environment for debugging sessions
dap_python.resolve_python = function()
  return get_poetry_python_path()
end

-- Configure Python adapter
dap.configurations.python = {
  {
    type = 'python',
    request = 'launch',
    name = "Launch file",
    program = "${file}",
    pythonPath = function()
      return get_poetry_python_path()
    end,
  },
  -- Add more configurations as needed
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
