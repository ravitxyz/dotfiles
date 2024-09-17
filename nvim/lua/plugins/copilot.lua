-- lua/plugins/copilot.lua

return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  config = function()
    require("copilot").setup({
      suggestion = {
        enabled = true,
        auto_trigger = false,
        keymap = {
          accept = false,
          next = false,
          prev = false,
          dismiss = "<C-]>",
        },
      },
      panel = { enabled = false },
    })

    local suggestion = require("copilot.suggestion")

    -- Function to toggle Copilot suggestions
    local function toggle_copilot()
      if suggestion.is_visible() then
        suggestion.dismiss()
      else
        suggestion.toggle_auto_trigger()
      end
    end

    -- Custom keymaps
    -- <C-j> to toggle Copilot in both normal and insert mode
    vim.keymap.set({'n', 'i'}, '<C-j>', toggle_copilot, { desc = "Toggle Copilot suggestion", silent = true })
    -- <C-k> to cycle through suggestions (insert mode only)
    vim.keymap.set('i', '<C-k>', function()
      if suggestion.is_visible() then
        suggestion.next()
      end
    end, { desc = "Next Copilot suggestion", silent = true })

    -- <C-l> to accept suggestion (insert mode only)
    vim.keymap.set('i', '<C-l>', function()
      if suggestion.is_visible() then
        suggestion.accept()
      end
    end, { desc = "Accept Copilot suggestion", silent = true })
  end,
}
