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
		javascript = is_linter_available("eslint") and { "eslint" } or {},
		typescript = is_linter_available("eslint") and { "eslint" } or {},
		cpp = is_linter_available("cpplint") and { "cpplint" } or {},
		c = is_linter_available("cpplint") and { "cpplint" } or {},
		go = is_linter_available("golangci-lint") and { "golangcilint" } or {},
		python = is_linter_available("pylint") and { "pylint" } or {},
		sh = is_linter_available("shellcheck") and { "shellcheck" } or {},
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

	-- Create a debounced version of the lint function
	local lint_timer = nil
	local function debounced_lint()
		if lint_timer then
			vim.fn.timer_stop(lint_timer)
		end
		lint_timer = vim.fn.timer_start(1000, function()
			local ft = vim.bo.filetype
			local linters = lint.linters_by_ft[ft] or {}
			if #linters > 0 then
				pcall(function()
					lint.try_lint()
				end)
			end
		end)
	end

	-- Autocommands for automatic linting
	-- Removed InsertLeave and added debouncing
	vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
		group = vim.api.nvim_create_augroup("NvimLintGroup", { clear = true }),
		callback = function()
			debounced_lint()
		end,
	})

	-- Optionally, add a more controlled InsertLeave trigger with longer debounce
	vim.api.nvim_create_autocmd("InsertLeave", {
		group = vim.api.nvim_create_augroup("NvimLintInsertGroup", { clear = true }),
		callback = function()
			-- Longer debounce for InsertLeave to prevent the space lag
			if lint_timer then
				vim.fn.timer_stop(lint_timer)
			end
			lint_timer = vim.fn.timer_start(2000, function()
				local ft = vim.bo.filetype
				local linters = lint.linters_by_ft[ft] or {}
				if #linters > 0 then
					pcall(function()
						lint.try_lint()
					end)
				end
			end)
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
end

return M
