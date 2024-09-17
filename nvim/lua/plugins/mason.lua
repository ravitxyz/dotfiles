return {
  "williamboman/mason.nvim",
  opts = {
    ensure_installed = {
      "pyright",
      "ruff",
      "debugpy",
      "lua-language-server",
    },
  },
}
