local M = { "folke/which-key.nvim" }

M.event = "VeryLazy"

function M.opts()
  return {
    preset = "modern",
    icons = { mappings = false }
  }
end

return M
