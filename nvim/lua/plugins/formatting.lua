return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>f",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = "",
      desc = "Format buffer",
    },
  },
  opts = {
    formatters_by_ft = {
      python = function(bufnr)
        -- Check if we're in a project with ruff config
        local cwd = vim.fn.getcwd()
        if string.find(cwd, "spellgrounds") then
          return { "ruff_format", "ruff_organize_imports" }
        elseif string.find(cwd, "hex") then
          return { "black" }
        else
          return { "ruff_format", "ruff_organize_imports" }
        end
      end,
      javascript = { "prettier" },
      typescript = { "prettier" },
      javascriptreact = { "prettier" },
      typescriptreact = { "prettier" },
      json = { "prettier" },
      jsonc = { "prettier" },
      css = { "prettier" },
      scss = { "prettier" },
      html = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },
      graphql = { "prettier" },
      lua = { "stylua" },
    },
    format_on_save = function(bufnr)
      -- Disable format_on_save for files where we don't want auto-formatting
      local disable_filetypes = { c = true, cpp = true }
      return {
        timeout_ms = 500,
        lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
      }
    end,
    formatters = {
      ruff_format = {
        command = "ruff",
        args = { "format", "--stdin-filename", "$FILENAME", "-" },
        stdin = true,
      },
      ruff_organize_imports = {
        command = "ruff",
        args = { "check", "--select", "I", "--fix", "--stdin-filename", "$FILENAME", "-" },
        stdin = true,
      },
    },
  },
  init = function()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}