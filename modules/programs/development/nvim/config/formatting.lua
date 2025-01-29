local M = {}
function M.setup()
    -- Cache the conform module
    local conform = require("conform")

    -- Define formatters with formatting options
    local formatters = {
        prettier = {
            prepend_args = { "--print-width", "100" },
        },
        black = {
            prepend_args = { "--line-length", "100" },
        },
        stylua = {
            prepend_args = { "--indent-type", "Spaces", "--indent-width", "4" },
        },
    }

    conform.setup({
        formatters = formatters,
        formatters_by_ft = {
            -- Web Development
            javascript = { "prettier" },
            typescript = { "prettier" },
            css = { "prettier" },
            html = { "prettier" },
            json = { "prettier" },
            yaml = { "prettier" },
            markdown = { "prettier" },
            -- Systems Programming
            rust = { "rustfmt" },
            c = { "clang-format" },
            cpp = { "clang-format" },
            go = { "gofmt", "goimports" },
            -- Scripting Languages
            python = { "black" },
            lua = { "stylua" },
            sh = { "shfmt" },
            -- Configuration
            nix = { "nixfmt" },
        },
        -- Format on save with debounce and longer timeout
        format_on_save = function(bufnr)
            -- Skip formatting on certain filetypes or buffer types
            local skip_filetypes = { "sql", "text" }
            local filetype = vim.bo[bufnr].filetype

            if vim.tbl_contains(skip_filetypes, filetype) then
                return
            end

            -- Add debounce to prevent multiple format calls
            local timer = vim.loop.new_timer()
            timer:start(
                100,
                0,
                vim.schedule_wrap(function()
                    conform.format({
                        bufnr = bufnr,
                        timeout_ms = 1000, -- Increased timeout
                        lsp_fallback = true,
                        async = true, -- Make formatting async
                    })
                end)
            )
        end,
        -- Add format notification
        notify_on_error = true,
    })

    -- Format keymap with async operation
    vim.keymap.set({ "n", "v" }, "<leader>f", function()
        conform.format({
            async = true,
            lsp_fallback = true,
            timeout_ms = 1000,
        })
    end, { desc = "Format file or range (in visual mode)" })
end

return M
