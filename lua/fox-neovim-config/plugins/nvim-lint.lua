local M = {"mfussenegger/nvim-lint"}

-- M.event = {"BufWritePost", "BufReadPost", "InsertLeave"}
--
function M.opts()
  return {
    linters_by_ft = {
        lua = {"luacheck"},
        make = {"checkmake"},
        cmake = {"cmakelint"},
        vim = {"vint"},
        markdown = {"markdownlint"},
        json = {"jsonlint"},
        python = {"mypy", "pylint", "flake8", "pycodestyle", "pydocstyle", "ruff"},
        rust = {"bacon"},
        yaml = {"yamllint"},
        sh = {"shellcheck"},
        proto = {"buf_lint"},
        gitcommit = {"commitlint"},
        gitignore = {"gitlint"},
        html = {"htmlhint"},
        groovy = {"npm-groovy-lint"},
        text = {"textlint"}
    }
  }
end

function M.config(_, opts)
    local lint = require("lint")
    lint.linters_by_ft = opts.linters_by_ft
    local lint_augroup = vim.api.nvim_create_augroup("lint", {clear = true})
    vim.api.nvim_create_autocmd({"BufWritePost", "BufReadPost", "InsertLeave"}, {
        group = lint_augroup,
        callback = function() require("lint").try_lint() end
    })
    vim.keymap.set("n", "<leader>l", function() require("lint").try_lint() end,
                   {desc = "Trigger linting for current file"})

end

return M
