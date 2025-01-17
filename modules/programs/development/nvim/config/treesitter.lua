local M = {}

function M.setup()
    require("nvim-treesitter.configs").setup({
        ensure_installed = {
            "lua", "python", "typescript", "javascript", "go",
            "rust", "c", "cpp", "java", "json", "yaml",
            "toml", "html", "css", "markdown", "markdown_inline",
        },
        sync_install = false,
        auto_install = true,
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
        indent = { enable = true },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "<CR>",
                node_incremental = "<CR>",
                node_decremental = "<BS>",
                scope_incremental = "<TAB>",
            },
        },
        textobjects = {
            select = {
                enable = true,
                lookahead = true,
                keymaps = {
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["ac"] = "@class.outer",
                    ["ic"] = "@class.inner",
                    ["aa"] = "@parameter.outer",
                    ["ia"] = "@parameter.inner",
                },
            },
            move = {
                enable = true,
                set_jumps = true,
                goto_next_start = {
                    ["]f"] = "@function.outer",
                    ["]c"] = "@class.outer",
                },
                goto_next_end = {
                    ["]F"] = "@function.outer",
                    ["]C"] = "@class.outer",
                },
                goto_previous_start = {
                    ["[f"] = "@function.outer",
                    ["[c"] = "@class.outer",
                },
                goto_previous_end = {
                    ["[F"] = "@function.outer",
                    ["[C"] = "@class.outer",
                },
            },
        },
    })
end

return M
