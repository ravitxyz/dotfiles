-- Consolidated LSP configuration
-- Note: This file has been updated to use ruff's native language server with `ruff server`
-- which provides both linting and formatting capabilities including import sorting
-- Common LSP keymaps setup function (moved to top level for reuse)
local function setup_lsp_keymaps(client, bufnr)
  local opts = { buffer = bufnr, noremap = true, silent = true }
  
  -- Code navigation with auto-close for definition
  vim.keymap.set("n", "gd", function()
    vim.lsp.buf.definition({
      on_list = function(options)
        if #options.items == 1 then
          -- Single definition - jump directly
          vim.fn.setqflist({}, ' ', options)
          vim.cmd('cfirst')
          vim.cmd('cclose')
        else
          -- Multiple definitions - show list with auto-close on selection
          vim.fn.setqflist({}, ' ', options)
          vim.cmd('copen')
          
          -- Set up auto-close when selecting from quickfix
          vim.api.nvim_create_autocmd("FileType", {
            pattern = "qf",
            once = true,
            callback = function()
              vim.keymap.set("n", "<CR>", function()
                local line = vim.api.nvim_get_current_line()
                vim.cmd('cc') -- Go to current quickfix item
                vim.cmd('cclose') -- Close quickfix
              end, { buffer = true, silent = true })
            end
          })
        end
      end
    })
  end, opts)
  
  vim.keymap.set("n", "gr", function()
    vim.lsp.buf.references(nil, {
      on_list = function(options)
        vim.fn.setqflist({}, ' ', options)
        vim.cmd('copen')
      end
    })
  end, opts)
  
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  
  -- Code actions
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
  
  -- Diagnostics
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
  vim.keymap.set("n", "<leader>le", vim.diagnostic.open_float, opts)
  vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)
end

return {
  -- Mason for installing language servers
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("mason").setup({
        ui = {
          border = "rounded",
        }
      })
      
      -- Ensure servers are installed
      require("mason-lspconfig").setup({
        ensure_installed = {
          "basedpyright", -- Python type checking
          "ruff",         -- Python linting and formatting
          "lua_ls",       -- Lua language server
          "html",         -- HTML
          "cssls",        -- CSS
          "jsonls",       -- JSON language server
          "eslint",       -- ESLint for TypeScript/JavaScript (Hex monorepo)
        },
        automatic_installation = false, -- Prevent auto-installation of unwanted servers
        handlers = {
          -- Default handler for most servers
          function(server_name)
            -- Aggressively skip ALL TypeScript servers
            if string.match(server_name:lower(), "typescript") or 
               string.match(server_name:lower(), "ts_ls") or 
               server_name == "tsserver" then
              print("Blocked TypeScript server: " .. server_name)
              return
            end
            require("lspconfig")[server_name].setup({
              on_attach = setup_lsp_keymaps,
            })
          end,
          -- Explicitly disable ALL TypeScript server variants
          ["ts_ls"] = function() print("Blocked ts_ls") end,
          ["tsserver"] = function() print("Blocked tsserver") end,
          ["typescript-language-server"] = function() print("Blocked typescript-language-server") end,
          ["typescript"] = function() print("Blocked typescript") end,
          ["typescript_language_server"] = function() print("Blocked typescript_language_server") end,
        },
      })
      
      -- Configure language servers
      local lspconfig = require("lspconfig")
      
      -- TypeScript language server has been uninstalled to prevent conflicts with typescript-tools
      -- No additional configuration needed
      
      -- ESLint language server (recommended for Hex monorepo)
      lspconfig.eslint.setup({
        on_attach = function(client, bufnr)
          -- Disable formatting (handled by prettier via conform.nvim)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
          setup_lsp_keymaps(client, bufnr)
        end,
        settings = {
          workingDirectory = { mode = "auto" }
        },
      })
      
      
      -- Basedpyright for Python type checking and language features
      lspconfig.basedpyright.setup({
        on_attach = function(client, bufnr)
          -- Disable formatting (handled by ruff)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
          setup_lsp_keymaps(client, bufnr)
        end,
        settings = {
          basedpyright = {
            analysis = {
              typeCheckingMode = "standard",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              autoImportCompletions = true,
            },
          },
        },
      })
      
      -- Ruff for Python linting and formatting using the native server
      lspconfig.ruff.setup({
        cmd = { "ruff", "server" },
        on_attach = function(client, bufnr)
          -- Disable hover (handled by basedpyright)
          client.server_capabilities.hoverProvider = false
          
          -- Keep formatting with the native server
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

      -- JSON
      lspconfig.jsonls.setup({
        on_attach = function(client, bufnr)
          -- Enable folding capability
          client.server_capabilities.foldingRangeProvider = true
          setup_lsp_keymaps(client, bufnr)
        end,
        settings = {
          json = {
            validate = { enable = true },
            format = { enable = true }
          }
        },
        filetypes = { "json", "jsonc" }
      })
    end,
  },
  
  -- TypeScript Tools
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {
      on_attach = function(client, bufnr)
        -- Set client name for identification
        client.name = "typescript-tools"

        -- Ensure folding capability is enabled
        if client.server_capabilities then
          client.server_capabilities.foldingRangeProvider = true
          -- Disable semantic tokens to prevent errors
          client.server_capabilities.semanticTokensProvider = nil
        end

        -- Use the centralized keymap setup function
        setup_lsp_keymaps(client, bufnr)
      end,
      settings = {
        -- Use single server for both language features and diagnostics
        separate_diagnostic_server = false,
        
        -- Diagnostic publication trigger
        publish_diagnostic_on = "insert_leave",
        
        -- TypeScript server file preferences
        tsserver_file_preferences = {
          includeInlayParameterNameHints = "all",
          quotePreference = "auto",
        },
        
        -- Enable folding ranges
        tsserver_plugins = {},
      },
    },
  },
}