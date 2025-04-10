-- Consolidated Python formatting configuration
return {
  -- Formatting with conform.nvim
  {
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
      -- Define formatters for Python
      formatters_by_ft = {
        python = { "ruff_format", "ruff_imports" },
      },
      -- Configure formatters
      formatters = {
        ruff_format = {
          command = "ruff",
          args = { "format", "--stdin-filename", "$FILENAME", "-" },
        },
        ruff_imports = {
          command = "ruff",
          args = { "check", "--select=I", "--fix", "--stdin-filename", "$FILENAME", "-" },
        },
      },
      -- Format on save settings
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    },
    init = function()
      -- Format on save for Python files only
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.py",
        callback = function(args)
          -- Check if buffer still exists to avoid errors on exit
          if vim.api.nvim_buf_is_valid(args.buf) then
            local success, err = pcall(function()
              require("conform").format({ bufnr = args.buf })
            end)
            if success then
              print("Ruff formatted file")
            else
              print("Format error: " .. tostring(err))
            end
          end
        end,
      })
    end,
  },
}