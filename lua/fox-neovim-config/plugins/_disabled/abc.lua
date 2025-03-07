local M = { "jisensee/abc.nvim" }

M.enabled = false
M.ft = 'abc'
M.opts = {}

function M.config(_, opts)
  require("abc-nvim").setup(opts)
end

return M
