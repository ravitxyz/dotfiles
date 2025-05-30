return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local harpoon = require("harpoon")
        local extensions = require("harpoon.extensions")

        -- REQUIRED
        harpoon:setup()
        -- REQUIRED

        harpoon:extend(extensions.builtins.navigate_with_number())

        vim.keymap.set("n", "<leader>ah", function()
            harpoon:list():add()
        end)
        vim.keymap.set("n", "<leader>th", function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end)

        -- Toggle previous & next buffers stored within Harpoon list
        vim.keymap.set("n", "<leader>ph", function()
            harpoon:list():prev()
        end)
        vim.keymap.set("n", "<leader>nh", function()
            harpoon:list():next()
        end)
    end,
}
