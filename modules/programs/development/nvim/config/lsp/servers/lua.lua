local M = {}

function M.setup()
    local lspconfig = require("lspconfig")
    local handlers = require("config.lsp.handlers").handlers

    lspconfig.lua_ls.setup({
        capabilities = handlers.capabilities,
        on_attach = handlers.on_attach,
        settings = {
            Lua = {
                runtime = {
                    version = "LuaJIT",
                },
                diagnostics = {
                    globals = { "vim" },
                },
                workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                    checkThirdParty = false,
                },
                telemetry = {
                    enable = false,
                },
            },
        },
    })
end

return M
