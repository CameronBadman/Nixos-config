local M = {}

function M.setup(lint, is_linter_available)
    if is_linter_available("clang-tidy") then
        lint.linters.clangtidy.args = {
            "--checks=*",
            "--warnings-as-errors=*",
            "-checks=-*,bugprone-*,cert-*,clang-analyzer-*,performance-*,portability-*,readability-*,modernize-*",
            "--header-filter=.*",
        }

        lint.linters_by_ft = lint.linters_by_ft or {}
        lint.linters_by_ft.c = { "clangtidy" }
        lint.linters_by_ft.cpp = { "clangtidy" }
    end
end

return M
