local M = {"mfussenegger/nvim-lint"}

M.event = {"BufNewFile", "BufReadPre"}
--
function M.opts()
    return {
        linters_by_ft = {
            uex = {"rstcheck"},
            lua = {"luacheck"},
            make = {"checkmake"},
            cmake = {"cmakelint"},
            cpp = {"cpplint"},
            vim = {"vint"},
            editorconfig = {"editorconfig-checker"},
            markdown = {"markdownlint"},
            javascript = {"eslint_d"},
            typescript = {"eslint_d"},
            json = {"jsonlint"},
            python = {"pylint", "ruff", "mypy", "flake8", "pydocstyle"},
            rust = {},
            yaml = {"yamllint"},
            sh = {"shellcheck"},
            proto = {"buf_lint"},
            gitcommit = {},
            gitignore = {},
            html = {"htmlhint"},
            groovy = {},
            text = {"codespell", "eslint_d"}
        }
    }
end

function M.config(_, opts)
    local lint = require("lint")
    lint.linters_by_ft = opts.linters_by_ft
    lint.linters.luacheck = {
        cmd = "luacheck",
        stdin = true,
        args = {"--globals", "vim", "lvim", "reload", "--"},
        stream = "stdout",
        ignore_exitcode = true,
        parser = require("lint.parser").from_errorformat("%f:%l:%c: %m",
                                                         {source = "luacheck"})
    }
    local lint_augroup = vim.api.nvim_create_augroup("lint", {clear = true})
    vim.api.nvim_create_autocmd({"BufEnter", "BufWritePost", "InsertLeave"}, {
        group = lint_augroup,
        callback = function() require("lint").try_lint() end
    })
    vim.keymap.set("n", "<leader>l", function() require("lint").try_lint() end,
                   {desc = "Trigger linting for current file"})
end

return M
