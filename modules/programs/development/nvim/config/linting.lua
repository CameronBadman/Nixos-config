local M = {}

function M.setup()
	require("lint").linters_by_ft = {
		-- Web Development
		javascript = { "eslint" },
		typescript = { "eslint" },
		-- Systems Programming
		cpp = { "cpplint" },
		c = { "cpplint" },
		go = { "golangci-lint" },
		-- Scripting Languages
		python = { "pylint" },
		sh = { "shellcheck" },
		-- Documentation/Text
		markdown = { "codespell" },
	}

	-- Autocommands for automatic linting
	vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
		callback = function()
			require("lint").try_lint()
		end,
	})

	-- Lint keymap
	vim.keymap.set("n", "<leader>l", function()
		require("lint").try_lint()
	end, { desc = "Trigger linting for current file" })

	-- Set diagnostic signs
	local signs = { Error = " ", Warn = " ", Hint = "󰌵 ", Info = " " }
	for type, icon in pairs(signs) do
		local hl = "DiagnosticSign" .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
	end
end

return M
