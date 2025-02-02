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

    -- Ensure sonarlint directory exists
    local sonarlint_dir = vim.fn.expand("~/.sonarlint")
    if vim.fn.isdirectory(sonarlint_dir) == 0 then
        vim.fn.mkdir(sonarlint_dir, "p")
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
            before_init = function(initialize_params)
                initialize_params.initializationOptions = {
                    telemetryStorage = sonarlint_dir,
                    productName = "Neovim",
                    productVersion = vim.version().version,
                    disableTelemetry = true,
                }
            end,
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
                    -- Explicitly disable telemetry
                    disableTelemetry = true,
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
        -- Add telemetry storage path here as well to ensure it's set
        init_options = {
            telemetryStorage = sonarlint_dir,
            disableTelemetry = true,
        },
    })
end

return M
