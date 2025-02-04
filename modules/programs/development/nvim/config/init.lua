-- Load all configurations
local function load_config()
    require("config.options").setup()
    require("config.lualine").setup()
    require("config.git").setup()
    require("config.kubectl").setup()
    require("config.editing").setup()
end

-- Initialize everything
load_config()
vim.lsp.set_log_level("debug")
return {
    setup = load_config,
}
