local M = {}

function M.setup()
    -- Define diagnostic signs
    local signs = {
        Error = " ",
        Warn = " ",
        Hint = " ",
        Info = " ",
    }

    -- Set up diagnostic signs
    for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end

    -- Configure diagnostic display
    vim.diagnostic.config({
        virtual_text = {
            prefix = "●",
            spacing = 4,
            source = "if_many",
            severity = {
                min = vim.diagnostic.severity.HINT,
            },
        },
        float = {
            border = "rounded",
            source = "always",
            header = "",
            prefix = "",
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
    })

    -- Configure hover and signature help windows
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
        width = 60,
        max_width = math.min(math.floor(vim.o.columns * 0.7), 100),
    })

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
        width = 60,
        max_width = math.min(math.floor(vim.o.columns * 0.7), 100),
    })
end

return M
