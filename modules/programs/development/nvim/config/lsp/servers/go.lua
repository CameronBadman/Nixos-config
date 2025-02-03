local M = {}

function M.setup()
    local lspconfig = require("lspconfig")
    local handlers = require("config.lsp.handlers").handlers

    lspconfig.gopls.setup({
        capabilities = handlers.capabilities,
        on_attach = handlers.on_attach,
        settings = {
            gopls = {
                analyses = {
                    unusedparams = true,
                    shadow = true,
                    nilness = true,
                    unusedwrite = true,
                    useany = true,
                },
                staticcheck = true,
                gofumpt = true,
                usePlaceholders = true,
                hints = {
                    assignVariableTypes = true,
                    compositeLiteralFields = true,
                    compositeLiteralTypes = true,
                    constantValues = true,
                    functionTypeParameters = true,
                    parameterNames = true,
                    rangeVariableTypes = true,
                },
            },
        },
    })
end

return M
