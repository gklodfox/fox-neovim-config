local M = { "kevinhwang91/nvim-ufo" }

M.event = "BufReadPost"
M.dependencies = { "kevinhwang91/promise-async", "nvim-treesitter/nvim-treesitter" }

function M.init()
  -- vim.o.foldenable = true
  -- vim.o.foldcolumn = "auto:9" -- '0' is not bad
  vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
  vim.o.foldlevelstart = 99
  --
  vim.keymap.set("n", "zR", require("ufo").openAllFolds)
  vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
  vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds)
  vim.keymap.set("n", "zm", require("ufo").closeFoldsWith)
end

function M.opts()
  return {
    filetype_exclude = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason" },
    provider_selector = function(bufnr, filetype, buftype)
      return { "treesitter", "indent" }
    end,
  }
end

function M.config(_, opts)
  require("ufo").setup(opts)
end

return M
