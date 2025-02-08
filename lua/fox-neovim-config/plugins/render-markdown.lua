local M = { "MeanderingProgrammer/render-markdown.nvim" }

M.dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }
M.ft = { "markdown" }

function M.opts()
  return {}
end

return M
