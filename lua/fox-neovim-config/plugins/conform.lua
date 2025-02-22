local M = { "stevearc/conform.nvim" }

function M.init()
  vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
end

function M.opts()
  local lua_formatters = { "stylua" }
  local clang_formatters = { "clang-format" }
  local cmake_formatters = { "cmake_format" }
  local python_formatters = {
    function(bufnr)
      if require("conform").get_formatter_info("ruff_format", bufnr).available then
        return { "ruff_format" }
      else
        return { "isort", "black" }
      end
    end,
  }
  local rust_formatters = { "rustfmt" }
  local yaml_formatters = { "yamlfmt", "yamlfix" }
  local json_formatters = { "fixjson" }
  local sh_formatters = { "shellcheck", "shfmt" }
  local all_formatters = { "codespell", "ast-grep" }
  local on_save_formatters = {}

  return {
    formatters_by_ft = {
      cmake = cmake_formatters,
      clang = clang_formatters,
      lua = lua_formatters,
      python = python_formatters,
      rust = rust_formatters,
      yaml = yaml_formatters,
      json = json_formatters,
      sh = sh_formatters,
      ["*"] = all_formatters,
      ["_"] = on_save_formatters,
    },
    format_on_save = false,
  }
end

function M.config(_, opts)
  local conform = require("conform")
  conform.setup(opts)

  vim.keymap.set({ "n", "v" }, "<leader>F", function()
    conform.format({
      lsp_fallback = true,
      async = false,
      timeout_ms = 500,
    })
  end, { desc = "Format current file or range" })
end

return M
