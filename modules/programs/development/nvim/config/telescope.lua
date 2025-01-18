local M = {}

function M.setup()
	local telescope = require("telescope")
	local actions = require("telescope.actions")

	-- Setup Telescope with default settings
	telescope.setup({
		defaults = {
			mappings = {
				i = {
					["<esc>"] = actions.close,
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
			vimgrep_arguments = {
				"rg",
				"--color=never",
				"--no-heading",
				"--with-filename",
				"--line-number",
				"--column",
				"--smart-case",
				"--hidden", -- Add this to search hidden files
				"--glob=!.git/*", -- but exclude .git directory
			},
		},
		pickers = {
			find_files = {
				theme = "dropdown",
				hidden = true,
				previewer = false,
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
				fuzzy = true,
				override_generic_sorter = true,
				override_file_sorter = true,
				case_mode = "smart_case",
			},
		},
	})

	-- Load the fzf extension if installed
	pcall(telescope.load_extension, "fzf")

	-- Set up keymaps
	local keymap_opts = { noremap = true, silent = true }

	-- File navigation
	vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", keymap_opts)
	vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", keymap_opts)
	vim.keymap.set("n", "<leader>fw", "<cmd>Telescope grep_string<CR>", keymap_opts) -- Search word under cursor
	vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", keymap_opts)
	vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", keymap_opts)

	-- Git navigation
	vim.keymap.set("n", "<leader>gc", "<cmd>Telescope git_commits<CR>", keymap_opts)
	vim.keymap.set("n", "<leader>gb", "<cmd>Telescope git_branches<CR>", keymap_opts)
	vim.keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<CR>", keymap_opts)

	-- LSP navigation (note: these might conflict with your LSP config)
	vim.keymap.set("n", "<leader>fr", "<cmd>Telescope lsp_references<CR>", keymap_opts)
	vim.keymap.set("n", "<leader>fd", "<cmd>Telescope lsp_definitions<CR>", keymap_opts)
	vim.keymap.set("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<CR>", keymap_opts)
end

return M
