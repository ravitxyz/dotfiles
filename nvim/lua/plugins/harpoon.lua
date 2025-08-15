return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local harpoon = require("harpoon")
        local extensions = require("harpoon.extensions")

        -- REQUIRED
        harpoon:setup({
            settings = {
                save_on_toggle = false,
                sync_on_ui_close = false,
            }
        })
        -- REQUIRED

        harpoon:extend(extensions.builtins.navigate_with_number())

        vim.keymap.set("n", "<leader>ah", function()
            harpoon:list():add()
        end)
        vim.keymap.set("n", "<leader>th", function()
            -- Handle potential swap file errors gracefully
            local ok, err = pcall(function()
                harpoon.ui:toggle_quick_menu(harpoon:list())
            end)
            if not ok then
                print("Harpoon error (try :recover or <leader>sw): " .. tostring(err))
            end
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
