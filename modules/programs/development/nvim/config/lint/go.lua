local M = {}

function M.setup(lint, is_linter_available)
    -- Configure golangci-lint with all available linters
    lint.linters.golangcilint = {
        cmd = "golangci-lint",
        args = {
            "run",
            "--enable-all",
            "--fix=false",
            "--out-format=line-number",

            -- Enable specific critical linters explicitly
            "--enable=errcheck", -- Error handling checks
            "--enable=gosec", -- Security checks
            "--enable=govet", -- Suspicious constructs
            "--enable=staticcheck", -- Static analysis
            "--enable=unused", -- Unused code
            "--enable=nilerr", -- Nil error returns
            "--enable=bodyclose", -- HTTP response body closure
            "--enable=contextcheck", -- Context inheritance
            "--enable=noctx", -- HTTP request context
            "--enable=sqlclosecheck", -- SQL resource closure
            "--enable=rowserrcheck", -- SQL rows.Err() checks
            "--enable=ineffassign", -- Ineffective assignments

            -- Disable a few overly strict ones
            "--disable=lll", -- Line length checks
            "--disable=gochecknoglobals", -- Global vars (too strict)
            "--disable=wsl", -- Whitespace (too opinionated)

            -- Path prefix for file locations
            "--path-prefix",
            vim.api.nvim_buf_get_name(0),
        },
        stdin = false,
        stream = "both",
        ignore_exitcode = true,
        parser = function(output, bufnr)
            -- Debug output to help diagnose issues
            print("golangci-lint raw output:", output)

            local diagnostics = {}
            for line in output:gmatch("[^\r\n]+") do
                -- Try different parsing patterns
                local file, row, col, message = line:match("([^:]+):(%d+):(%d+):%s*(.+)")
                if not file then
                    file, row, col, message = line:match("([^:]+):(%d+):(%d+)%s*(.+)")
                end

                if file and row and col and message then
                    local severity = vim.diagnostic.severity.WARN

                    -- Enhanced pattern matching for critical issues
                    if
                        message:match("error")
                        or message:match("missing error handling")
                        or message:match("unchecked error")
                        or message:match("Rows.Err")
                        or message:match("nil pointer")
                        or message:match("SQL")
                        or message:match("context")
                        or message:match("leak")
                        or message:match("security")
                        or message:match("unsafe")
                        or message:match("race condition")
                        or message:match("unhandled error")
                        or message:match("missing context")
                        or message:match("http request")
                        or message:match("response body not closed")
                        or message:match("should not use dot imports")
                        or message:match("should check errors")
                        or message:match("should handle error")
                        or message:match("magic number")
                        or message:match("error strings should not be capitalized")
                        or message:match("error return value not checked")
                    then
                        severity = vim.diagnostic.severity.ERROR
                    end

                    table.insert(diagnostics, {
                        lnum = tonumber(row) - 1,
                        col = tonumber(col) - 1,
                        message = message,
                        source = "golangci-lint",
                        severity = severity,
                    })
                end
            end
            return diagnostics
        end,
    }

    -- Register Go linters
    lint.linters_by_ft = lint.linters_by_ft or {}
    lint.linters_by_ft.go = {}

    if is_linter_available("golangci-lint") then
        table.insert(lint.linters_by_ft.go, "golangcilint")
    end
end

return M
