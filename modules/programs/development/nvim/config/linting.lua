local M = {}

function M.setup()
	local status_ok, lint = pcall(require, "lint")
	if not status_ok then
		vim.notify("nvim-lint not loaded", vim.log.levels.ERROR)
		return
	end

	-- Configure linters with available binaries
	local function is_linter_available(linter_name)
		return vim.fn.executable(linter_name) == 1
	end

	local linters_by_ft = {
		-- Web Development
		javascript = is_linter_available("eslint") and { "eslint" } or {},
		typescript = is_linter_available("eslint") and { "eslint" } or {},
		-- Systems Programming
		cpp = is_linter_available("cpplint") and { "cpplint" } or {},
		c = is_linter_available("cpplint") and { "cpplint" } or {},
		go = is_linter_available("golangci-lint") and { "golangcilint" } or {},
		-- Scripting Languages
		python = is_linter_available("pylint") and { "pylint" } or {},
		sh = is_linter_available("shellcheck") and { "shellcheck" } or {},
		-- Documentation/Text
		markdown = is_linter_available("codespell") and { "codespell" } or {},
	}

	-- Custom configuration for Go linter
	lint.linters.golangcilint = {
		cmd = "golangci-lint",
		stdin = false,
		args = { "run", "--out-format=line-number" },
		stream = "stdout",
		ignore_exitcode = true,
		parser = require("lint.linters.golangcilint").parser,
	}

	-- Set linters
	lint.linters_by_ft = linters_by_ft

	-- Autocommands for automatic linting
	vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
		group = vim.api.nvim_create_augroup("NvimLintGroup", { clear = true }),
		callback = function(event)
			local ft = vim.bo[event.buf].filetype
			local linters = lint.linters_by_ft[ft] or {}

			-- Only try to lint if linters are available
			if #linters > 0 then
				pcall(function()
					lint.try_lint()
				end)
			end
		end,
	})

	-- Lint keymap
	vim.keymap.set("n", "<leader>l", function()
		pcall(function()
			lint.try_lint()
		end)
	end, { desc = "Trigger linting for current file" })

	-- Set diagnostic signs
	local signs = { Error = " ", Warn = " ", Hint = "󰌵 ", Info = " " }
	for type, icon in pairs(signs) do
		local hl = "DiagnosticSign" .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
	end

	-- Debug logging
	vim.notify("Linting configuration loaded", vim.log.levels.INFO)
end

return M
