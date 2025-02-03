local M = {}

function M.setup()
    local lspconfig = require('lspconfig')
    local handlers = require('config.lsp.handlers').handlers

    lspconfig.nil_ls.setup({
        capabilities = handlers.capabilities,
        on_attach = handlers.on_attach,
        settings = {
            ['nil'] = {
                formatting = {
                    command = { "nixfmt" },
                },
                nix = {
                    maxMemoryMB = 2048,
                    flake = {
                        autoArchive = true,
                    },
                },
            },
        },
    })
end

return M
