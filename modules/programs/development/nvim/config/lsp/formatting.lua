local M = {}

function M.setup()
    local null_ls = require("null-ls") -- Changed from none-ls to null-ls
    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

    null_ls.setup({
        sources = {
            -- JavaScript/TypeScript formatting
            null_ls.builtins.formatting.prettier.with({
                extra_args = {
                    "--single-quote",
                    "--jsx-single-quote",
                    "--trailing-comma",
                    "es5",
                    "--arrow-parens",
                    "avoid",
                },
                prefer_local = "node_modules/.bin",
            }),

            -- Go formatting
            null_ls.builtins.formatting.gofumpt,
            null_ls.builtins.formatting.goimports,

            -- Lua formatting
            null_ls.builtins.formatting.stylua.with({
                extra_args = {
                    "--indent-type",
                    "Spaces",
                    "--indent-width",
                    "2",
                },
            }),

            -- Nix formatting
            null_ls.builtins.formatting.nixfmt,

            -- Diagnostics
            null_ls.builtins.diagnostics.eslint.with({
                prefer_local = "node_modules/.bin",
            }),
            null_ls.builtins.diagnostics.golangci_lint,
        },

        on_attach = function(client, bufnr)
            if client.supports_method("textDocument/formatting") then
                vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                vim.api.nvim_create_autocmd("BufWritePre", {
                    group = augroup,
                    buffer = bufnr,
                    callback = function()
                        vim.lsp.buf.format({
                            bufnr = bufnr,
                            timeout_ms = 2000,
                        })
                    end,
                })
            end
        end,
    })
end

return M
