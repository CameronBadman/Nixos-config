local M = {}

function M.setup(lint, is_linter_available)
    if is_linter_available("shellcheck") then
        lint.linters.shellcheck.args = {
            "--format=gcc",
            "--external-sources",
            "--shell=bash",
            "--severity=style",
        }

        lint.linters_by_ft = lint.linters_by_ft or {}
        lint.linters_by_ft.sh = { "shellcheck" }
    end
end

return M
