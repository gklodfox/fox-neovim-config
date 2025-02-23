local M = { "mfussenegger/nvim-lint" }

M.event = { "BufNewFile", "BufReadPre" }
--
function M.opts()
  return {
    linters_by_ft = {
      tex = {},
      lua = { "luacheck" },
      make = { "checkmake" },
      cmake = { "cmakelint" },
      vim = { "vint" },
      markdown = { "markdownlint" },
      json = { "jsonlint" },
      python = { "pylint", "flake8", "pydocstyle", "ruff" },
      rust = {},
      yaml = { "yamllint" },
      sh = { "shellcheck" },
      proto = { "buf_lint" },
      gitcommit = {},
      gitignore = {},
      html = { "htmlhint" },
      groovy = {},
      text = { "codespell" },
    },
  }
end

function M.config(_, opts)
  local lint = require("lint")
  lint.linters_by_ft = opts.linters_by_ft
  lint.linters.luacheck = {
    cmd = "luacheck",
    stdin = true,
    args = {
      "--globals",
      "vim",
      "lvim",
      "reload",
      "--",
    },
    stream = "stdout",
    ignore_exitcode = true,
    parser = require("lint.parser").from_errorformat("%f:%l:%c: %m", {
      source = "luacheck",
    }),
  }
  local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
    group = lint_augroup,
    callback = function()
      require("lint").try_lint()
    end,
  })
  vim.keymap.set("n", "<leader>l", function()
    require("lint").try_lint()
  end, { desc = "Trigger linting for current file" })
end

return M
