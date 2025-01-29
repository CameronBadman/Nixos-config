local M = {}

function M.setup()
    -- Color palette matching Kanagawa theme
    local colors = {
        bg = "#1F1F28", -- Background
        bg_dark = "#16161D", -- Darker background
        bg_light = "#2A2A37", -- Lighter background
        fg = "#DCD7BA", -- Foreground (text)
        yellow = "#FF9E3B", -- Yellow
        cyan = "#7FB4CA", -- Cyan
        blue = "#7E9CD8", -- Blue
        green = "#98BB6C", -- Green
        orange = "#FFA066", -- Orange
        magenta = "#957FB8", -- Magenta
        red = "#E46876", -- Red
        bright = {
            yellow = "#FF9E3B",
            blue = "#7E9CD8",
            green = "#98BB6C",
            red = "#E46876",
            magenta = "#957FB8",
        },
    }

    local theme = {
        normal = {
            a = { fg = colors.bg, bg = colors.blue, gui = "bold" },
            b = { fg = colors.bright.blue, bg = colors.bg_light },
            c = { fg = colors.fg, bg = "NONE" },
        },
        insert = {
            a = { fg = colors.bg, bg = colors.green, gui = "bold" },
            b = { fg = colors.bright.green, bg = colors.bg_light },
            c = { fg = colors.fg, bg = "NONE" },
        },
        visual = {
            a = { fg = colors.bg, bg = colors.magenta, gui = "bold" },
            b = { fg = colors.bright.magenta, bg = colors.bg_light },
            c = { fg = colors.fg, bg = "NONE" },
        },
        replace = {
            a = { fg = colors.bg, bg = colors.red, gui = "bold" },
            b = { fg = colors.bright.red, bg = colors.bg_light },
            c = { fg = colors.fg, bg = "NONE" },
        },
        command = {
            a = { fg = colors.bg, bg = colors.yellow, gui = "bold" },
            b = { fg = colors.bright.yellow, bg = colors.bg_light },
            c = { fg = colors.fg, bg = "NONE" },
        },
        inactive = {
            a = { fg = colors.fg, bg = colors.bg_dark, gui = "bold" },
            b = { fg = colors.fg, bg = colors.bg },
            c = { fg = colors.fg, bg = "NONE" },
        },
    }

    -- Custom file format icons
    local function get_fileformat_icon()
        local icons = {
            unix = "", -- Linux
            dos = "", -- Windows
            mac = "", -- macOS
        }
        return icons[vim.bo.fileformat] or ""
    end

    require("lualine").setup({
        options = {
            theme = theme,
            component_separators = { left = "│", right = "│" },
            section_separators = { left = "", right = "" },
            globalstatus = true, -- Ensure lualine is visible across all splits
            disabled_filetypes = {
                statusline = {}, -- Ensure lualine is always visible
                winbar = {},
            },
        },
        sections = {
            lualine_a = {
                {
                    "mode",
                    separator = { left = "", right = "" },
                    padding = 2,
                    fmt = function(str)
                        local mode_icons = {
                            NORMAL = "󰆾 ",
                            INSERT = "󰏫 ",
                            VISUAL = "󰈈 ",
                            ["V-LINE"] = "󰈈 ",
                            ["V-BLOCK"] = "󰈈 ",
                            REPLACE = "󰮂 ",
                            COMMAND = "󰘳 ",
                        }
                        return mode_icons[str] and mode_icons[str] .. str or str
                    end,
                },
            },
            lualine_b = {
                {
                    "branch",
                    icon = "󰊢",
                    padding = { left = 1, right = 1 },
                },
                {
                    "diff",
                    symbols = {
                        added = "󰐕 ",
                        modified = "󰝤 ",
                        removed = "󰍴 ",
                    },
                    padding = { left = 1, right = 1 },
                },
            },
            lualine_c = {
                {
                    "filename",
                    path = 1,
                    symbols = {
                        modified = "●",
                        readonly = "󰌾",
                        unnamed = "[No Name]",
                        newfile = "󰎔",
                    },
                },
            },
            lualine_x = {
                {
                    "diagnostics",
                    sources = { "nvim_diagnostic" },
                    sections = { "error", "warn", "info", "hint" },
                    symbols = {
                        error = "󰅚 ",
                        warn = "󰀦 ",
                        info = "󰋼 ",
                        hint = "󰌶 ",
                    },
                },
                { "encoding", icons_enabled = true, icon = "󰁨" },
                {
                    "fileformat",
                    icons_enabled = true,
                    fmt = get_fileformat_icon,
                },
                {
                    "filetype",
                    icons_enabled = true,
                    icon_only = true,
                    padding = { left = 1, right = 0 },
                },
                {
                    "filetype",
                    icons_enabled = false,
                    padding = { left = 1, right = 2 },
                },
            },
            lualine_y = {
                {
                    "progress",
                    icon = "󰜎",
                    padding = { left = 1, right = 1 },
                },
            },
            lualine_z = {
                {
                    "location",
                    separator = { left = "", right = "" },
                    padding = 2,
                    icon = "󰍒",
                },
            },
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { "filename" },
            lualine_x = { "location" },
            lualine_y = {},
            lualine_z = {},
        },
    })
end

return M
