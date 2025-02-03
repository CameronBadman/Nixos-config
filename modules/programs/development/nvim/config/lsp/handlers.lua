local M = {}

-- Store handlers for use across modules
M.handlers = {}

function M.setup()
    -- Set up completion capabilities
    M.handlers.capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- Define common on_attach function for all language servers
    M.handlers.on_attach = function(client, bufnr)
        -- Enable completion triggered by <C-x><C-o>
        vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

        -- LSP keymaps
        local opts = { noremap = true, silent = true, buffer = bufnr }

        -- Code navigation
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "<leader>gt", vim.lsp.buf.type_definition, opts)

        -- Documentation and help
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>k", vim.lsp.buf.signature_help, opts)

        -- Code actions
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

        -- Diagnostic navigation
        vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
        vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)

        -- Set up format on save if supported
        if client.server_capabilities.documentFormattingProvider then
            vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format({
                        buffer = bufnr,
                        timeout_ms = 2000,
                    })
                end,
            })
        end
    end
end

return M
