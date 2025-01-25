-- editing.lua

local M = {}

function M.setup()
	-- multicursors.nvim Configuration
	local multicursors_ok, multicursors = pcall(require, "multicursors")
	if multicursors_ok then
		multicursors.setup({
			hint = {
				float_opts = {
					border = "rounded", -- Border style for hints
				},
				position = "bottom", -- Position of hints
			},
			generate_hints = {
				normal = true, -- Enable hints in normal mode
				insert = true, -- Enable hints in insert mode
				extend = true, -- Enable hints in visual mode
			},
		})

		-- Keybindings for multicursors.nvim
		vim.api.nvim_set_keymap(
			"n",
			"<Leader>m",
			'<Cmd>lua require("multicursors").start()<CR>',
			{ noremap = true, silent = true }
		)
		vim.api.nvim_set_keymap(
			"x",
			"<Leader>m",
			'<Cmd>lua require("multicursors").start()<CR>',
			{ noremap = true, silent = true }
		)
	else
		print("multicursors.nvim not found!")
	end
end

return M
