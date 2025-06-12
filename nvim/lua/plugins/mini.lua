return {
    'echasnovski/mini.nvim', 
    version = false,
    config = function()
        -- Text Editing modules
        require('mini.ai').setup({
            n_lines = 500,
        })
        
        require('mini.surround').setup({
            mappings = {
                add = 'sa',            -- Add surrounding in Normal and Visual modes
                delete = 'sd',         -- Delete surrounding
                find = 'sf',           -- Find surrounding (to the right)
                find_left = 'sF',      -- Find surrounding (to the left)
                highlight = 'sh',      -- Highlight surrounding
                replace = 'sr',        -- Replace surrounding
                update_n_lines = 'sn', -- Update `n_lines`
            },
        })
        
        require('mini.operators').setup({
            evaluate = {
                prefix = 'g=',
            },
            exchange = {
                prefix = 'gx',
            },
            multiply = {
                prefix = 'gm',
            },
            replace = {
                prefix = 'gr',
            },
            sort = {
                prefix = 'gs',
            },
        })
        
        -- Navigation & Files modules
        require('mini.files').setup({
            content = {
                filter = nil,
                prefix = nil,
                sort = nil,
            },
            mappings = {
                close = 'q',
                go_in = 'l',
                go_in_plus = 'L',
                go_out = 'h',
                go_out_plus = 'H',
                reset = '<BS>',
                reveal_cwd = '@',
                show_help = 'g?',
                synchronize = '=',
                trim_left = '<',
                trim_right = '>',
            },
            options = {
                permanent_delete = true,
                use_as_default_explorer = false,
            },
        })
        
        require('mini.pick').setup({
            delay = {
                async = 10,
                busy = 50,
            },
            mappings = {
                caret_left = '<Left>',
                caret_right = '<Right>',
                choose = '<CR>',
                choose_in_split = '<C-s>',
                choose_in_tabpage = '<C-t>',
                choose_in_vsplit = '<C-v>',
                choose_marked = '<M-CR>',
                delete_char = '<BS>',
                delete_char_right = '<Del>',
                delete_left = '<C-u>',
                delete_word = '<C-w>',
                mark = '<C-x>',
                mark_all = '<C-a>',
                move_down = '<C-n>',
                move_start = '<C-g>',
                move_up = '<C-p>',
                paste = '<C-r>',
                refine = '<C-Space>',
                refine_marked = '<M-Space>',
                scroll_down = '<C-f>',
                scroll_left = '<C-h>',
                scroll_right = '<C-l>',
                scroll_up = '<C-b>',
                stop = '<Esc>',
                toggle_info = '<S-Tab>',
                toggle_preview = '<Tab>',
            },
        })
        
        require('mini.bracketed').setup({
            buffer     = { suffix = 'b', options = {} },
            comment    = { suffix = 'c', options = {} },
            conflict   = { suffix = 'x', options = {} },
            diagnostic = { suffix = 'd', options = {} },
            file       = { suffix = 'f', options = {} },
            indent     = { suffix = 'i', options = {} },
            jump       = { suffix = 'j', options = {} },
            location   = { suffix = 'l', options = {} },
            oldfile    = { suffix = 'o', options = {} },
            quickfix   = { suffix = 'q', options = {} },
            treesitter = { suffix = 't', options = {} },
            undo       = { suffix = 'u', options = {} },
            window     = { suffix = 'w', options = {} },
            yank       = { suffix = 'y', options = {} },
        })
        
        -- Utility modules
        require('mini.comment').setup({
            options = {
                custom_commentstring = nil,
                ignore_blank_line = false,
                start_of_line = false,
                pad_comment_parts = true,
            },
            mappings = {
                comment = 'gc',
                comment_line = 'gcc',
                comment_visual = 'gc',
                textobject = 'gc',
            },
        })
        
        require('mini.pairs').setup({
            modes = { insert = true, command = false, terminal = false },
            skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
            skip_ts = { 'string' },
            skip_unbalanced = true,
            markdown = true,
        })
        
        require('mini.move').setup({
            mappings = {
                left = '<M-h>',
                right = '<M-l>',
                down = '<M-j>',
                up = '<M-k>',
                line_left = '<M-h>',
                line_right = '<M-l>',
                line_down = '<M-j>',
                line_up = '<M-k>',
            },
        })
        
        require('mini.align').setup({
            mappings = {
                start = 'ga',
                start_with_preview = 'gA',
            },
        })
        
        -- Set up keymaps for mini.files
        vim.keymap.set('n', '<leader>mf', function()
            require('mini.files').open()
        end, { desc = 'Open mini.files' })
        
        -- Set up keymaps for mini.pick (alternative to telescope)
        vim.keymap.set('n', '<leader>pf', function()
            require('mini.pick').builtin.files()
        end, { desc = 'Pick files' })
        
        vim.keymap.set('n', '<leader>pg', function()
            require('mini.pick').builtin.grep_live()
        end, { desc = 'Pick grep live' })
        
        vim.keymap.set('n', '<leader>pb', function()
            require('mini.pick').builtin.buffers()
        end, { desc = 'Pick buffers' })
    end,
}
