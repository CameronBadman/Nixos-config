local M = {}

function M.setup()
	-- Setup sonarlint first
	require("config.sonarlint").setup()

	local lspconfig = require("lspconfig")
	local capabilities = require("cmp_nvim_lsp").default_capabilities()

	-- Server configurations
	local servers = {
		gopls = {},
		rust_analyzer = {},
		ts_ls = { -- Changed from tsserver
			root_dir = lspconfig.util.root_pattern("package.json"),
		},
		lua_ls = {
			settings = {
				Lua = {
					diagnostics = { globals = { "vim" } },
				},
			},
		},
		nil_ls = {},
	}

	-- Setup each server
	for server, config in pairs(servers) do
		if lspconfig[server] then -- Check if server exists
			config.capabilities = capabilities
			lspconfig[server].setup(config)
		else
			vim.notify("LSP server " .. server .. " not found", vim.log.levels.WARN)
		end
	end

	-- Configure diagnostic settings
	vim.diagnostic.config({
		virtual_text = true, -- Show diagnostics beside the code
		signs = true, -- Show diagnostic signs in the sign column
		underline = true, -- Underline text with diagnostic
		update_in_insert = false, -- Don't update diagnostics in insert mode
		severity_sort = true, -- Sort diagnostics by severity
		float = {
			border = "rounded", -- Add border to floating windows
			source = "always", -- Always show diagnostic source
			header = "", -- No header in diagnostic window
			prefix = "", -- No prefix in diagnostic window
		},
	})

	-- Set diagnostic signs
	local signs = {
		Error = " ",
		Warn = " ",
		Hint = "󰌵 ",
		Info = " ",
	}

	for type, icon in pairs(signs) do
		local hl = "DiagnosticSign" .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
	end

	-- Add borders to hover and signature help
	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "rounded",
	})

	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "rounded",
	})

	-- LSP Keymaps
	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("UserLspConfig", {}),
		callback = function(ev)
			local opts = { buffer = ev.buf }

			-- Navigation
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
			vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
			vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
			vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)

			-- Documentation
			vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
			vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)

			-- Workspace management
			vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
			vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
			vim.keymap.set("n", "<leader>wl", function()
				print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			end, opts)

			-- Code actions
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

			-- Diagnostics
			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
			vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
			vim.keymap.set("n", "<leader>f", function()
				vim.lsp.buf.format({ async = true })
			end, opts)
		end,
	})
end

return M
