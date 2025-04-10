return {
  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.black,
          null_ls.builtins.diagnostics.flake8,
        },
      })

      -- Autoformat on save
      vim.cmd [[autocmd BufWritePre *.py lua vim.lsp.buf.format()]]

      -- Keymaps
      vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)
    end,
  },
}
