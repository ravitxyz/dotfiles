if vim.g.vscode then
    -- VSCode extension
require("ravit.set")
require("ravit.keymaps")
else
    -- ordinary Neovim
require("ravit.set")
require("ravit.packer")
require("ravit.keymaps")
end

