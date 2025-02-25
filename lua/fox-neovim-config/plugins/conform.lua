local M = { "stevearc/conform.nvim" }

function M.init()
  vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
end

function M.opts()
  local lua_formatters = { "stylua" }
  local clangd_formatters = { "clang-format" }
  local cmake_formatters = { "cmake_format" }
  local tex_formatters = { "bibtex-tidy" }
  local python_formatters = {
    "ruff_format",
    --   else
    --     return { "isort", "black" }
    --   end
    -- end,
  }
  local rust_formatters = { "rustfmt" }
  local yaml_formatters = { "yamlfmt", "yamlfix" }
  local json_formatters = { "fixjson" }
  local sh_formatters = { "shellcheck", "shfmt" }
  local all_formatters = { "codespell" }
  local on_save_formatters = { "codespell" }

  return {
    formatters_by_ft = {
      tex = tex_formatters,
      cmake = cmake_formatters,
      clangd = clangd_formatters,
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
      timeout_ms = 1500,
    })
  end, { desc = "Format current file or range" })
end

return M
