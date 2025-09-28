local M = {"norcalli/nvim-colorizer.lua"}

-- M.event = "BufEnter"
M.opts = {"*"}
function M.config(_, opts) require("colorizer").setup(opts) end

return M
