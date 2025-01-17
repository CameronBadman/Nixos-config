local M = {}

function M.setup()
    -- Color palette matching your Alacritty theme
    local colors = {
        bg = "#1d1f21",
        bg_dark = "#161719",
        bg_light = "#2d2f31",
        fg = "#c5c8c6",
        yellow = "#f0c674",
        cyan = "#8abeb7",
        darkblue = "#81a2be",
        green = "#b5bd68",
        orange = "#de935f",
        magenta = "#b294bb",
        blue = "#81a2be",
        red = "#cc6666",
        bright = {
            yellow = "#e7c547",
            blue = "#7aa6da",
            green = "#b9ca4a",
            red = "#d54e53",
            magenta = "#c397d8",
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
            unix = " ",
            dos = " ",
            mac = " ",
        }
        return icons[vim.bo.fileformat] or ""
    end

    require("lualine").setup({
        options = {
            theme = theme,
            component_separators = { left = "│", right = "│" },
            section_separators = { left = "", right = "" },
            globalstatus = true,
            disabled_filetypes = {
                statusline = { "neo-tree" },
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
                            INSERT = " ",
                            VISUAL = "󰈈 ",
                            ["V-LINE"] = "󰈈 ",
                            ["V-BLOCK"] = "󰈈 ",
                            REPLACE = " ",
                            COMMAND = " ",
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
                        added = " ",
                        modified = "󰝤 ",
                        removed = " ",
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
                        error = " ",
                        warn = " ",
                        info = " ",
                        hint = "󰌵 ",
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
