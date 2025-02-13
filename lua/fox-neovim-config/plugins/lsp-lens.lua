local M = { "VidocqH/lsp-lens.nvim" }

function M.opts()
  local SymbolKind = vim.lsp.protocol.SymbolKind

  return {
    include_declaration = true, -- Reference includes declaration
    sections = { -- Enable / Disable specific requests
      definition = true,
      references = true,
      implements = true,
      git_authors = true,
    },
    ignore_filetype = { "prisma" },
    target_symbol_kinds = { SymbolKind.Function, SymbolKind.Method, SymbolKind.Interface },
    wrapper_symbol_kinds = { SymbolKind.Class, SymbolKind.Struct },
  }
end

return M

