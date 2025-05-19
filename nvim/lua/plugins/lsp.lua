-- Consolidated LSP configuration
-- Note: This file has been updated to use ruff's native language server with `ruff server`
-- which provides both linting and formatting capabilities including import sorting
return {
  -- Mason for installing language servers
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      -- Common LSP keymaps setup function
      local function setup_lsp_keymaps(client, bufnr)
        local opts = { buffer = bufnr, noremap = true, silent = true }
        
        -- Code navigation
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        
        -- Code actions
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        
        -- Diagnostics
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
        vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
        vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)
      end

      require("mason").setup({
        ui = {
          border = "rounded",
        }
      })
      
      -- Ensure servers are installed
      require("mason-lspconfig").setup({
        ensure_installed = {
          -- "basedpyright", -- Python type checking (removed in favor of ruff only)
          "ruff",         -- Python linting and formatting
          "lua_ls",       -- Lua language server
          "tsserver",     -- JavaScript/TypeScript
          "html",         -- HTML
          "cssls",        -- CSS
        },
        automatic_installation = true,
      })
      
      -- Configure language servers
      local lspconfig = require("lspconfig")
      
      -- Basedpyright configuration removed in favor of using only ruff
      
      -- Ruff for Python linting and formatting using the native server
      lspconfig.ruff.setup({
        cmd = { "ruff", "server" },
        on_attach = function(client, bufnr)
          -- Enable hover to replace basedpyright
          client.server_capabilities.hoverProvider = true
          
          -- Enable formatting with the native server
          client.server_capabilities.documentFormattingProvider = true
          client.server_capabilities.documentRangeFormattingProvider = true
          
          -- Format on save with both formatting and import organization
          local augroup = vim.api.nvim_create_augroup("RuffFormatting", {})
          vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
              -- First organize imports with ruff check command
              local file_path = vim.api.nvim_buf_get_name(bufnr)
              local cmd = string.format("ruff check --select=I --fix \"%s\"", file_path)
              vim.fn.system(cmd)
              
              -- Then format the file with the LSP
              vim.lsp.buf.format({ 
                bufnr = bufnr, 
                async = false,
                filter = function(server)
                  return server.name == "ruff"
                end
              })
              print("Ruff formatted file with imports organized")
            end,
            desc = "Format using Ruff with import organization on save",
          })
          
          -- Setup basic keymaps
          setup_lsp_keymaps(client, bufnr)
        end,
        
        -- Enable import organization and other features
        settings = {
          -- Enable auto-organization of imports with format on save
          organizeImports = true,
          -- Enable formatting
          format = {
            on_save = true
          },
          -- Enable line length formatting
          lineLength = 100,
          -- Preview options for newer features
          args = {"--preview"}
        }
      })
      
      -- Lua language server
      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = {
              enable = false,
            },
          },
        },
        on_attach = function(client, bufnr)
          setup_lsp_keymaps(client, bufnr)
        end,
      })

      -- TypeScript/JavaScript
      lspconfig.tsserver.setup({
        on_attach = function(client, bufnr)
          -- Disable formatting (use prettier or other formatters instead)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
          setup_lsp_keymaps(client, bufnr)
        end,
        filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "javascript.jsx", "typescript.tsx" },
        cmd = { "typescript-language-server", "--stdio" }
      })

      -- HTML
      lspconfig.html.setup({
        on_attach = function(client, bufnr)
          setup_lsp_keymaps(client, bufnr)
        end,
        filetypes = { "html" },
        init_options = {
          configurationSection = { "html", "css", "javascript" },
          embeddedLanguages = {
            css = true,
            javascript = true
          },
          provideFormatter = true
        }
      })

      -- CSS
      lspconfig.cssls.setup({
        on_attach = function(client, bufnr)
          setup_lsp_keymaps(client, bufnr)
        end,
        filetypes = { "css", "scss", "less" }
      })
    end,
  },
}