local M = { "kevinhwang91/nvim-ufo" }

M.dependencies = { "kevinhwang91/promise-async" }

function M.init()
  vim.o.foldenable = true
  vim.o.foldcolumn = "1" -- '0' is not bad
  vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
  vim.o.foldlevelstart = 99
end

function M.opts()
  return { filetype_exclude = {
    "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason"
  }}
end

function M.config(_, opts)
  require("ufo").setup(opts)
end

return M
