local M = {}

function M.setup(lint, is_linter_available)
    if is_linter_available("eslint") then
        lint.linters.eslint.args = {
            "--format=unix",
            "--quiet",
        }

        lint.linters_by_ft = lint.linters_by_ft or {}
        lint.linters_by_ft.javascript = { "eslint" }
        lint.linters_by_ft.typescript = { "eslint" }
    end
end

return M
