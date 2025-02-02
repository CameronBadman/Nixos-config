local M = {}

function M.setup()
    local lspconfig = require("lspconfig")
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- First register sonarlint configuration with fixed testFilePattern
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
                "cs",
            },
            root_dir = lspconfig.util.root_pattern(
                ".git",
                "pyproject.toml",
                "setup.py",
                "pom.xml",
                "package.json",
                "go.mod",
                "*.sln",
                "*.csproj"
            ),
            single_file_support = true,
            settings = {
                sonarlint = {
                    disableTelemetry = true,
                    output = {
                        showAnalyzerLogs = true,
                        showVerboseLogs = true,
                    },
                    pathToNodeExecutable = "node",
                    testFilePattern = "*_test.go",
                    rules = {
                        ["python:S1135"] = {
                            level = "off",
                        },
                    },
                    analysisOnSave = true,
                    analysisOnType = true,
                    analysisOnOpen = true,
                },
            },
        },
    }

    -- Server configurations
    local servers = {
        gopls = {
            settings = {
                gopls = {
                    analyses = {
                        nilness = true,
                        unusedparams = true,
                        unusedwrite = true,
                        useany = true,
                        unusedvariable = true,
                        deepequalerrors = true,
                        shadow = true,
                        deprecation = true,
                        httpresponse = true,
                        ifaceassert = true,
                        composites = true,
                        copylocks = true,
                        errorsas = true,
                        timeformat = true,
                        shift = true,
                        structtag = true,
                        ST1013 = true,
                    },
                    staticcheck = true,
                    usePlaceholders = true,
                    completeUnimported = true,
                    gofumpt = true,
                    buildFlags = { "-tags=all" },
                    diagnosticsDelay = "0ms",
                    semanticTokens = true,
                    codelenses = {
                        gc_details = true,
                        generate = true,
                        regenerate_cgo = true,
                        tidy = true,
                        upgrade_dependency = true,
                        vendor = true,
                    },
                    hints = {
                        assignVariableTypes = true,
                        compositeLiteralFields = true,
                        compositeLiteralTypes = true,
                        constantValues = true,
                        functionTypeParameters = true,
                        parameterNames = true,
                        rangeVariableTypes = true,
                    },
                    templateExtensions = {},
                },
            },
        },
        clangd = {
            cmd = { "clangd" },
            filetypes = { "c", "cpp" },
            root_dir = lspconfig.util.root_pattern("compile_commands.json", "CMakeLists.txt", "Makefile", ".git"),
            settings = {
                clangd = {
                    fallbackFlags = { "-std=c17" },
                },
            },
        },
        rust_analyzer = {},
        ts_ls = {
            root_dir = lspconfig.util.root_pattern("package.json"),
        },
        lua_ls = {
            settings = {
                Lua = {
                    diagnostics = { globals = { "vim" } },
                    workspace = {
                        checkThirdParty = false,
                    },
                    telemetry = {
                        enable = false,
                    },
                    completion = {
                        callSnippet = "Replace",
                    },
                },
            },
        },
        nil_ls = {},
        sonarlint = {},
        omnisharp = {
            cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
            filetypes = { "cs", "csproj", "sln" },
            root_dir = lspconfig.util.root_pattern("*.sln", "*.csproj"),
            settings = {
                RoslynExtensionsOptions = {
                    EnableAnalyzersSupport = true,
                    EnableImportCompletion = true,
                },
                FormattingOptions = {
                    EnableEditorConfigSupport = true,
                },
            },
        },
    }

    -- Setup each server
    for server, config in pairs(servers) do
        if lspconfig[server] then
            config.capabilities = capabilities
            lspconfig[server].setup(config)
        else
            vim.notify("LSP server " .. server .. " not found", vim.log.levels.WARN)
        end
    end

    -- Enhanced diagnostic settings
    vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
            border = "rounded",
            source = "always",
            header = "",
            prefix = "",
            format = function(diagnostic)
                if diagnostic.code then
                    return string.format("%s [%s]", diagnostic.message, diagnostic.code)
                end
                return diagnostic.message
            end,
        },
    })

    -- Diagnostic handler setup
    local orig_handler = vim.lsp.handlers["textDocument/publishDiagnostics"]
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(orig_handler, {
        update_in_insert = false,
        debounce = 300,
    })

    -- Diagnostic signs with icons
    local signs = {
        Error = "󰅚 ",
        Warn = "󰀦 ",
        Hint = "󰌶 ",
        Info = "󰋼 ",
    }

    for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end

    -- Enhanced hover and signature help
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
        max_width = 80,
        max_height = 20,
    })

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
        max_width = 80,
        max_height = 20,
    })

    -- LSP Keymaps
    vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
            local opts = { buffer = ev.buf }

            -- Navigation
            vim.keymap.set("n", "<leader>ld", vim.lsp.buf.declaration, opts)
            vim.keymap.set("n", "<leader>lf", vim.lsp.buf.definition, opts)
            vim.keymap.set("n", "<leader>li", vim.lsp.buf.implementation, opts)
            vim.keymap.set("n", "<leader>lr", vim.lsp.buf.references, opts)
            vim.keymap.set("n", "<leader>lt", vim.lsp.buf.type_definition, opts)

            -- Documentation
            vim.keymap.set("n", "<leader>lh", vim.lsp.buf.hover, opts)
            vim.keymap.set("n", "<leader>ls", vim.lsp.buf.signature_help, opts)

            -- Workspace management
            vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
            vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
            vim.keymap.set("n", "<leader>wl", function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, opts)

            -- Code actions
            vim.keymap.set("n", "<leader>ln", vim.lsp.buf.rename, opts)
            vim.keymap.set({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, opts)

            -- Diagnostics navigation and display
            vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
            vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
            vim.keymap.set("n", "<leader>f", function()
                vim.lsp.buf.format({ async = true })
            end, opts)
            vim.keymap.set("n", "<leader>ll", vim.diagnostic.setloclist, opts)
            vim.keymap.set("n", "<leader>lq", vim.diagnostic.setqflist, opts)
        end,
    })
end

return M
