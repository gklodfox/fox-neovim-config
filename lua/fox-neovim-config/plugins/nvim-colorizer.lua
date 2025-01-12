local M = { "norcalli/nvim-colorizer.lua" }

M.event = "BufEnter"

function M.config()
  require("colorizer").setup({'*'})
end

return M
