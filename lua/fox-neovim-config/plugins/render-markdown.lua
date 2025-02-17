local M = { "MeanderingProgrammer/render-markdown.nvim" }

M.dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }
M.ft = { "markdown" }
M.opts = {}

function M.config(_, opts)
  require("render-markdown").setup(opts)
end

return M
