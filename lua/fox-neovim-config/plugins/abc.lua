local M = { "jisensee/abc.nvim" }

M.ft = 'abc'

function M.config()
  require("abc-nvim").setup()
end

return M
