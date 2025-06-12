return {
    "ruifm/gitlinker.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
        require("gitlinker").setup({
            opts = {
                remote = nil, -- Auto-detect remote
                add_current_line_on_normal_mode = true,
                action_callback = require("gitlinker.actions").copy_to_clipboard,
                print_url = true,
            },
            mappings = "<leader>gy", -- Default mapping
        })
    end,
}