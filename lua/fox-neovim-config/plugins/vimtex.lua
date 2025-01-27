local M = { "lervag/vimtex" }

M.lazy = false
function M.init()
  vim.g.vimtex_view_method = "zathura"
end

return M
