-- Load all configurations
local function load_config()
    require("config.options").setup()
    require("config.treesitter").setup()
    require("config.neo-tree").setup()
    require("config.lualine").setup()
    require("config.telescope").setup()
    require("config.git").setup()
    require("config.kubectl").setup()
    require("config.formatting").setup()
    require("config.lsp").setup()
    require("config.completion").setup()
    require("config.editing").setup()
    require("config.lint").setup()
end

-- Initialize everything
load_config()
vim.lsp.set_log_level("debug")
return {
    setup = load_config,
}
