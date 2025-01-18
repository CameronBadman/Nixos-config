local M = {}

function M.setup()
	-- Leader keys
	vim.g.mapleader = " "
	vim.g.maplocalleader = " "

	-- Options
	vim.opt.number = true
	vim.opt.relativenumber = true
	vim.opt.mouse = "a"
	vim.opt.showmode = false
	vim.opt.clipboard = "unnamedplus"
	vim.opt.breakindent = true
	vim.opt.undofile = true
	vim.opt.ignorecase = true
	vim.opt.smartcase = true
	vim.opt.signcolumn = "yes"
	vim.opt.updatetime = 250
	vim.opt.timeoutlen = 300
	vim.opt.splitright = true
	vim.opt.splitbelow = true
	vim.opt.list = true
	vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
	vim.opt.inccommand = "split"
	vim.opt.cursorline = true
	vim.opt.scrolloff = 10
	vim.opt.hlsearch = false

	-- Tab settings
	vim.opt.tabstop = 2 -- Number of spaces tabs count for
	vim.opt.softtabstop = 2 -- Number of spaces a tab counts for during editing
	vim.opt.shiftwidth = 2 -- Number of spaces for indentation
	vim.opt.expandtab = true -- Use spaces instead of tabs

	-- Basic Keymaps
	vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>")
	vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
	vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
	vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })
end

return M
