local M = {}

function M.setup()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    
    -- Setup Telescope with default settings
    telescope.setup({
        defaults = {
            mappings = {
                i = {
                    ["<esc>"] = actions.close, -- Close telescope on ESC
                    ["<C-j>"] = actions.move_selection_next,
                    ["<C-k>"] = actions.move_selection_previous,
                },
            },
            file_ignore_patterns = {
                "node_modules",
                ".git/",
                "dist/",
                "build/",
            },
        },
        pickers = {
            find_files = {
                theme = "dropdown", -- Visual tweaks for better UX
                hidden = true, -- Show hidden files
                previewer = false, -- Disable previewer for find_files
            },
            live_grep = {
                theme = "dropdown",
            },
            buffers = {
                theme = "dropdown",
                previewer = false,
            },
        },
        extensions = {
            fzf = {
                fuzzy = true, -- Enable fuzzy matching
                override_generic_sorter = true, -- Override default sorter with fzf
                override_file_sorter = true, -- Override file sorter with fzf
                case_mode = "smart_case", -- Enable smart case
            },
        },
    })

    -- Load the fzf extension if installed
    pcall(telescope.load_extension, "fzf")

    -- Set up keymaps
    local keymap_opts = { noremap = true, silent = true }
    
    -- File navigation
    vim.api.nvim_set_keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>", keymap_opts)
    vim.api.nvim_set_keymap("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", keymap_opts)
    vim.api.nvim_set_keymap("n", "<leader>fb", "<cmd>Telescope buffers<CR>", keymap_opts)
    vim.api.nvim_set_keymap("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", keymap_opts)
    
    -- Git navigation
    vim.api.nvim_set_keymap("n", "<leader>gc", "<cmd>Telescope git_commits<CR>", keymap_opts)
    vim.api.nvim_set_keymap("n", "<leader>gb", "<cmd>Telescope git_branches<CR>", keymap_opts)
    vim.api.nvim_set_keymap("n", "<leader>gs", "<cmd>Telescope git_status<CR>", keymap_opts)
    
    -- LSP navigation
    vim.api.nvim_set_keymap("n", "gr", "<cmd>Telescope lsp_references<CR>", keymap_opts)
    vim.api.nvim_set_keymap("n", "gd", "<cmd>Telescope lsp_definitions<CR>", keymap_opts)
    vim.api.nvim_set_keymap("n", "<leader>ds", "<cmd>Telescope lsp_document_symbols<CR>", keymap_opts)
end

return M
