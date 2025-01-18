local M = {}

function M.setup()
	require("conform").setup({
		-- Format options
		formatters_by_ft = {
			-- Web Development
			javascript = { "prettier" },
			typescript = { "prettier" },
			css = { "prettier" },
			html = { "prettier" },
			json = { "prettier" },
			yaml = { "prettier" },
			markdown = { "prettier" },
			-- Systems Programming
			rust = { "rustfmt" },
			c = { "clang-format" },
			cpp = { "clang-format" },
			go = { "gofmt", "goimports" },
			-- Scripting Languages
			python = { "black" },
			lua = { "stylua" },
			sh = { "shfmt" },
			-- Configuration
			nix = { "nixfmt" },
		},
		-- Format on save
		format_on_save = {
			timeout_ms = 500,
			lsp_fallback = true,
		},
	})

	-- Format keymap
	vim.keymap.set({ "n", "v" }, "<leader>f", function()
		require("conform").format({
			async = true,
			lsp_fallback = true,
		})
	end, { desc = "Format file or range (in visual mode)" })
end

return M
