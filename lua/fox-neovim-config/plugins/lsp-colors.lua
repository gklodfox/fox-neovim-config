local M = { "folke/lsp-colors.nvim" }

-- M.event = "User FilePost"

function M.opts()
  return {
    Error = "#FF10F0",
    Warning = "#AA00A0",
    Hint = "#1BAEFA",
    Information = "#5BCEFA",
  }
end

return M
