return {
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
      formatters_by_ft = {
        python = { "ruff_format" },
      },
      formatters = {
        ruff_format = {
          prepend_args = { "--select=I" },
        },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    },
    init = function()
      -- Format on save
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.py",
        callback = function(args)
          require("conform").format({ bufnr = args.buf })
          print("Ruff formatted file on save")
        end,
      })
    end,
  },
}