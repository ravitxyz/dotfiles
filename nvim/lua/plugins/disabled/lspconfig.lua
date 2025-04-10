return {
	"neovim/nvim-lspconfig",
	config = function()
		local lspconfig = require("lspconfig")

		-- Python configuration
		lspconfig.basedpyright.setup({
			settings = {
				python = {
					analysis = {
						typeCheckingMode = "basic",
						autoSearchPaths = true,
						useLibraryCodeForTypes = true,
					},
				},
			},
		})

		-- Ruff LSP for diagnostics only
		lspconfig.ruff.setup({
			on_attach = function(client, bufnr)
				-- Disable hover in favor of basedpyright
				client.server_capabilities.hoverProvider = false
				-- Disable formatting (handled by conform.nvim)
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.documentRangeFormattingProvider = false
				
				-- Setup keymaps
				vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, 
					{ buffer = bufnr, desc = "Code actions" })
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, 
					{ buffer = bufnr, desc = "Go to definition" })
				vim.keymap.set("n", "gr", vim.lsp.buf.references, 
					{ buffer = bufnr, desc = "Go to references" })
				vim.keymap.set("n", "K", vim.lsp.buf.hover, 
					{ buffer = bufnr, desc = "Show documentation" })
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, 
					{ buffer = bufnr, desc = "Rename symbol" })
			end
		})
	end
}
