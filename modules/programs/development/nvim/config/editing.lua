-- ~/.config/nvim/lua/config/vim-visual-multi.lua

local M = {}

function M.setup()
    -- Configure vim-visual-multi
    vim.g.VM_maps = {
        -- Enable automatic selection
        ["Find Under"] = "<C-n>", -- Use Ctrl+n to start multicursor mode on the current word
        ["Find Subword Under"] = "<C-m>", -- Use Ctrl+m to start multicursor mode on the current subword

        -- Add cursors with Ctrl+hjkl (only in multicursor mode)
        ["Add Cursor Down"] = "<C-j>", -- Add a cursor below using Ctrl+j
        ["Add Cursor Up"] = "<C-k>", -- Add a cursor above using Ctrl+k
        ["Add Cursor Left"] = "<C-h>", -- Add a cursor to the left using Ctrl+h
        ["Add Cursor Right"] = "<C-l>", -- Add a cursor to the right using Ctrl+l

        -- Remove cursors with Alt+hjkl (only in multicursor mode)
        ["Remove Cursor Down"] = "<A-j>", -- Deselect cursor below using Alt+j
        ["Remove Cursor Up"] = "<A-k>", -- Deselect cursor above using Alt+k
        ["Remove Cursor Left"] = "<A-h>", -- Deselect cursor to the left using Alt+h
        ["Remove Cursor Right"] = "<A-l>", -- Deselect cursor to the right using Alt+l

        -- Select all occurrences of the current word
        ["Select All"] = "<Leader>a", -- Map <Leader>a to select all occurrences

        -- Disable default hjkl mappings for vim-visual-multi
        ["Motion j"] = "", -- Unmap j
        ["Motion k"] = "", -- Unmap k
        ["Motion h"] = "", -- Unmap h
        ["Motion l"] = "", -- Unmap l
    }

    -- Customize multicursor appearance
    vim.g.VM_theme = "purple" -- Available themes: "default", "purple", "red", "blue", "green"
    vim.g.VM_highlight_matches = "underline" -- Highlight matches with underline
    vim.g.VM_mouse_mappings = 0 -- Disable mouse support for multicursors
end

return M
