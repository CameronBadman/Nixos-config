local M = {}

function M.setup()
    local lspconfig = require("lspconfig")
    local handlers = require("config.lsp.handlers").handlers

    lspconfig.tsserver.setup({
        capabilities = handlers.capabilities,
        on_attach = function(client, bufnr)
            -- Disable tsserver formatting in favor of prettier
            client.server_capabilities.documentFormattingProvider = false
            handlers.on_attach(client, bufnr)
        end,
        settings = {
            typescript = {
                inlayHints = {
                    includeInlayParameterNameHints = "all",
                    includeInlayEnumMemberValueHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayVariableTypeHints = true,
                },
            },
            javascript = {
                inlayHints = {
                    includeInlayParameterNameHints = "all",
                    includeInlayEnumMemberValueHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayVariableTypeHints = true,
                },
            },
        },
    })
end

return M
