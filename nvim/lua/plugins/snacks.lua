return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        -- Enable the features you want
        bigfile = { enabled = true },
        notifier = { enabled = true },
        quickfile = { enabled = true },
        statuscolumn = { enabled = false },
        words = { enabled = true },
        picker = { enabled = true },
    },
    keys = {
        -- File finding
        { "<leader>f", function() Snacks.picker.files() end, desc = "Find Files" },
        { "<leader>sf", function() Snacks.picker.files() end, desc = "Find Files" },
        { "<leader>sg", function() Snacks.picker.git_files() end, desc = "Git Files" },

        -- Grep / Search
        { "<leader>st", function() Snacks.picker.grep() end, desc = "Live Grep (use file:path/ to filter)" },
        { "<leader>sT", function() Snacks.picker.grep_word() end, desc = "Grep Word Under Cursor" },

        -- Buffers and recent files
        { "<leader>o", function() Snacks.picker.buffers() end, desc = "Buffers" },
        { "<leader>sb", function() Snacks.picker.buffers() end, desc = "Buffers" },
        { "<leader>so", function() Snacks.picker.recent() end, desc = "Recent Files" },

        -- Git
        { "<leader>sc", function() Snacks.picker.git_log() end, desc = "Git Commits" },
        { "<leader>sB", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
        { "<leader>sm", function() Snacks.picker.git_status() end, desc = "Git Status" },

        -- LSP and diagnostics
        { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
        { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },

        -- Other useful pickers
        { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Tags" },
        { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
        { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
        { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
        { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
        { "<leader>sR", function() Snacks.picker.registers() end, desc = "Registers" },
        { "<leader>sl", function() Snacks.picker.resume() end, desc = "Resume Last Picker" },

        -- Undo tree
        { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo Tree" },
    },
    init = function()
        vim.api.nvim_create_autocmd("User", {
            pattern = "VeryLazy",
            callback = function()
                -- Setup some globals for easy access
                _G.Snacks = require("snacks")
            end,
        })
    end,
}
