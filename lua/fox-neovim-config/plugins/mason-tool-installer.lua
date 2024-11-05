local M = { "WhoIsSethDaniel/mason-tool-installer.nvim" }

M.dependencies = "williamboman/mason-lspconfig.nvim"

function M.opts()
  return {
    auto_update = true,
    ensure_installed = {
      "stylua",
      "prettier",
      "isort",
      "black",
      "pylint",
      "eslint_d",
      "shellcheck",
      "editorconfig-checker",
      "autopep8",
      "cmakelang",
      "clang-format",
      "markdownlint",
      "npm-groovy-lint",
      "jsonnetfmt",
      "yamlfmt",
      "codespell",
      "cpplint",
    },
    integrations = {
      ['mason-lspconfig'] = true
    }
  }
end

return M
