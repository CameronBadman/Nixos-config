local M = {}
function M.setup()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local compare = require("cmp.config.compare")

    -- Load friendly-snippets lazily
    require("luasnip/loaders/from_vscode").lazy_load()

    -- Base configuration
    local base_sources = {
        { name = "nvim_lsp", priority = 1000 },
        { name = "luasnip", priority = 750 },
        { name = "buffer", priority = 500, keyword_length = 5, max_item_count = 10 }, -- Increased minimum length for buffer completion
        { name = "path", priority = 250 },
    }

    -- Performance optimizations for completion
    local performance_config = {
        throttle_time = 80,
        source_timeout = 200,
        max_view_entries = 10, -- Limit the number of items shown
        preselect = cmp.PreselectMode.None,
        completion = {
            keyword_length = 2, -- Start completion after 2 characters
            completeopt = "menu,menuone,noinsert,noselect",
        },
    }

    cmp.setup({
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end,
        },
        mapping = cmp.mapping.preset.insert({
            ["<M-k>"] = cmp.mapping.select_prev_item(),
            ["<M-j>"] = cmp.mapping.select_next_item(),
            ["<M-h>"] = cmp.mapping.scroll_docs(-4),
            ["<M-l>"] = cmp.mapping.scroll_docs(4),
            ["<Esc>"] = cmp.mapping.abort(), -- Changed from close() to abort()
            ["<CR>"] = cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Insert,
                select = true,
            }),
            ["<Tab>"] = cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Insert,
                select = true,
            }),
        }),
        sorting = {
            priority_weight = 2,
            comparators = {
                -- Reduced number of comparators for better performance
                compare.offset,
                compare.exact,
                compare.score,
                compare.recently_used,
                compare.kind,
            },
        },
        sources = base_sources,
        formatting = {
            format = function(entry, vim_item)
                -- Moved icons to a local table for better performance
                local kind_icons = {
                    Text = "󰉿",
                    Method = "󰆧",
                    Function = "󰊕",
                    Constructor = "",
                    Field = "󰜢",
                    Variable = "󰀫",
                    Class = "󰠱",
                    Interface = "",
                    Module = "",
                    Property = "󰜢",
                    Unit = "󰑭",
                    Value = "󰎠",
                    Enum = "",
                    Keyword = "󰌋",
                    Snippet = "",
                    Color = "󰏘",
                    File = "󰈙",
                    Reference = "󰈇",
                    Folder = "󰉋",
                    EnumMember = "",
                    Constant = "󰏿",
                    Struct = "󰙅",
                    Event = "",
                    Operator = "󰆕",
                    TypeParameter = "",
                }

                vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind)
                vim_item.menu = ({
                    nvim_lsp = "[LSP]",
                    luasnip = "[Snip]",
                    buffer = "[Buf]",
                    path = "[Path]",
                    cmdline = "[CMD]",
                })[entry.source.name]
                return vim_item
            end,
        },
        window = {
            completion = cmp.config.window.bordered({
                winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
            }),
            documentation = cmp.config.window.bordered({
                winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
            }),
        },
        experimental = {
            ghost_text = false, -- Disabled ghost_text for better performance
        },
        performance = performance_config,
    })

    -- Simplified cmdline configuration
    cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = "buffer", max_item_count = 10 } },
    })

    cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = "cmdline", max_item_count = 10 } },
    })
end

return M
