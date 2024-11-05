local M = { 'kevinhwang91/nvim-ufo' }

M.dependencies = 'kevinhwang91/promise-async'

function M.init()
  vim.o.foldcolumn = '0' -- '0' is not bad
  vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
  vim.o.foldlevelstart = 99
  vim.o.foldenable = true
end

function M.config()
  local ufo = require("ufo")

  vim.keymap.set('n', 'zR', ufo.openAllFolds)
  vim.keymap.set('n', 'zM', ufo.closeAllFolds)
  vim.keymap.set('n', 'zr', ufo.openFoldsExceptKinds)
  vim.keymap.set('n', 'zm', ufo.closeFoldsWith)

  ufo.setup({
    provider_selector = function(bufnr, filetype, buftype)
        return {'treesitter', 'indent'}
    end
  })
end

return M
