local M = {}

local function setup_signs()
    local signs = { Error = " ", Warn = " ", Hint = "󰌵 ", Info = " " }
    for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end
end

local function is_linter_available(linter_name)
    local is_available = vim.fn.executable(linter_name) == 1
    if not is_available then
        vim.notify(
            string.format(
                "Linter '%s' not found in PATH. Make sure it's installed via nix-shell or home-manager",
                linter_name
            ),
            vim.log.levels.WARN
        )
    end
    return is_available
end

function M.setup()
    local status_ok, lint = pcall(require, "lint")
    if not status_ok then
        vim.notify("nvim-lint not loaded", vim.log.levels.ERROR)
        return
    end

    -- Load all linter configurations with correct paths
    local linters = {
        require("config.lint.go"),
        require("config.lint.python"),
        require("config.lint.javascript"),
        require("config.lint.c"),
        require("config.lint.shell"),
    }

    -- Initialize all linters
    for _, linter in ipairs(linters) do
        if linter.setup then
            linter.setup(lint, is_linter_available)
        end
    end

    -- Set up auto linting
    local lint_timer = nil
    local function debounced_lint()
        if lint_timer then
            vim.fn.timer_stop(lint_timer)
        end
        local delay = vim.bo.filetype == "go" and 500 or 1000
        lint_timer = vim.fn.timer_start(delay, function()
            local ft = vim.bo.filetype
            local linters = lint.linters_by_ft[ft] or {}
            if #linters > 0 then
                pcall(function()
                    lint.try_lint()
                end)
            end
        end)
    end

    -- Set up autocommands
    vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
        group = vim.api.nvim_create_augroup("NvimLintGroup", { clear = true }),
        callback = debounced_lint,
    })

    -- Set up keymaps
    vim.keymap.set("n", "<leader>l", function()
        pcall(function()
            lint.try_lint()
        end)
    end, { desc = "Trigger linting for current file" })

    setup_signs()
end

return M
