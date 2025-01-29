local M = {}

function M.setup()
    local lspconfig = require("lspconfig")
    local util = require("lspconfig.util")

    -- Check if sonarlint-ls exists
    local sonarlint_cmd = vim.fn.exepath("sonarlint-ls")
    if sonarlint_cmd == "" then
        vim.notify("sonarlint-ls executable not found", vim.log.levels.WARN)
        return
    end

    -- Register the sonarlint server configuration
    require("lspconfig.configs").sonarlint = {
        default_config = {
            cmd = { "sonarlint-ls", "stdio" },
            filetypes = {
                "python",
                "cpp",
                "typescript",
                "javascript",
                "java",
                "go",
            },
            root_dir = util.root_pattern(".git", "pyproject.toml", "setup.py", "pom.xml", "package.json", "go.mod"),
            single_file_support = true,
            settings = {
                sonarlint = {
                    pathToNodeExecutable = "node",
                    testFilePattern = {
                        "test/**/*",
                        "src/test/**/*",
                        "*_test.go",
                    },
                    -- Enable all rules
                    rules = {
                        enabled = true, -- Enable all rules by default
                    },
                    -- Enable analysis of all files
                    files = {
                        includePattern = "**/*",
                    },
                    -- Output settings
                    output = {
                        showAnalyzerLogs = true,
                        showVerboseLogs = true,
                    },
                    -- Analysis settings
                    analysis = {
                        verbose = true,
                        fullFilePath = true,
                        autoAnalysis = true,
                    },
                },
            },
            -- Configure SonarLint specific handlers
            handlers = {
                ["textDocument/publishDiagnostics"] = function(err, method, params, client_id, ...)
                    -- Modify diagnostic severity to always be Warning (yellow)
                    if params.diagnostics then
                        for _, diagnostic in ipairs(params.diagnostics) do
                            diagnostic.severity = vim.diagnostic.severity.WARN
                        end
                    end
                    vim.lsp.handlers["textDocument/publishDiagnostics"](err, method, params, client_id, ...)
                end,
            },
        },
    }

    -- Setup the server with any additional options
    lspconfig.sonarlint.setup({
        -- You can add any custom settings here if needed
    })
end

return M
