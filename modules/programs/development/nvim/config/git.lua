local M = {}

function M.setup()
    -- Git keymaps
    vim.keymap.set("n", "<leader>gs", ":Git<CR>", { desc = "Git status" })
    vim.keymap.set("n", "<leader>gd", ":Gdiff<CR>", { desc = "Git diff" })
    vim.keymap.set("n", "<leader>gb", ":Git blame<CR>", { desc = "Git blame" })
    vim.keymap.set("n", "<leader>gl", ":Git log<CR>", { desc = "Git log" })

    -- TODO: Add autocmds for fugitive window following
    -- We can implement this by setting up autocmds that track buffer changes
    -- and update the fugitive window accordingly
end

return M
