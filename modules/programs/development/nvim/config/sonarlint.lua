local lspconfig = require("lspconfig")
local util = require("lspconfig.util")

-- Register the sonarlint server configuration
lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
	cmd = { "sonarlint-language-server", "-stdio" },
	filetypes = {
		"python",
		"cpp",
		"typescript",
		"javascript",
		"java",
		"go",
	},
	root_dir = util.root_pattern(".git", "pyproject.toml", "setup.py", "pom.xml", "package.json", "go.mod"),
	single_file_support = true,
	settings = {
		sonarlint = {
			pathToNodeExecutable = "node",
			testFilePattern = {
				"test/**/*",
				"src/test/**/*",
				"*_test.go", -- Added Go test pattern
			},
		},
	},
})

local M = {}
function M.setup()
	lspconfig.sonarlint.setup({})
end

return M
