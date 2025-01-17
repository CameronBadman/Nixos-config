-- modules/programs/development/nvim/config/init.lua

-- Load all configurations
local function load_config()
    -- Basic settings and options are handled in neovim.nix

    -- Load individual module configurations
    require("config.treesitter").setup()
    require("config.neo-tree").setup()
    require("config.lualine").setup()
    require("config.telescope").setup()
    require("config.git").setup()
    -- Future modules will be loaded here as we add them
    -- require("config.lsp").setup()
    -- require("config.telescope").setup()
    -- require("config.completion").setup()
    -- etc...
end

-- Initialize everything
load_config()
