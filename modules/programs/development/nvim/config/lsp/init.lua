local M = {}

function M.setup()
    -- Load individual language server configurations
    require('config.lsp.servers.typescript').setup()
    require('config.lsp.servers.go').setup()
    require('config.lsp.servers.lua').setup()
    require('config.lsp.servers.nix').setup()
end

return M
