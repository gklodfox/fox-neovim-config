local M = { "folke/lsp-colors.nvim" }

function M.opts()
  return {
    Error = "#FF10F0",
    Warning = "#AA00A0",
    Hint = "#1BAEFA",
    Information = "#5BCEFA",
  }
end

function M.config(_, opts)
  require("lsp-colors").setup(opts)
end

return M
