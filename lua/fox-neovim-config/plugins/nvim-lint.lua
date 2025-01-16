local M = {"mfussenegger/nvim-lint"}

M.event = {"BufWritePost", "BufReadPost", "InsertLeave"}
function M.config(_, opts)
    local lint = require("lint")
    lint.linters_by_ft = {
        -- lua = {},
        vim = {"vint"},
        markdown = {"markdownlint"},
        json = {"jsonlint"},
        python = {"pylint", "pydocstyle"},
        rust = {"clippy"},
        yaml = {"yamllint"},
        sh = {"shellcheck"},
        proto = {"buf_lint"},
        groovy = {"npm-groovy-lint"}
    }
    local lint_augroup = vim.api.nvim_create_augroup("lint", {clear = true})

    vim.api.nvim_create_autocmd({"BufEnter", "BufWritePost", "InsertLeave"}, {
        group = lint_augroup,
        callback = function() lint.try_lint() end
    })
    vim.keymap.set("n", "<leader>l", function() lint.try_lint() end,
                   {desc = "Trigger linting for current file"})
end

return M
