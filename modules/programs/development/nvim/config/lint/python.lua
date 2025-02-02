local M = {}

function M.setup(lint, is_linter_available)
    if is_linter_available("pylint") then
        lint.linters.pylint.args = {
            "--output-format=text",
            "--score=no",
            "--msg-template={path}:{line}:{column}:{C}:{msg}",
            "--max-line-length=120",
        }

        lint.linters_by_ft = lint.linters_by_ft or {}
        lint.linters_by_ft.python = { "pylint" }
    end
end

return M
