local M = { "VidocqH/lsp-lens.nvim" }

function M.opts()
  local SymbolKind = vim.lsp.protocol.SymbolKind

  return {
    enable = true,
    include_declaration = false, -- Reference include declaration
    sections = { -- Enable / Disable specific request, formatter example looks 'Format Requests'
      definition = false,
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
