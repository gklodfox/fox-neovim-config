local M = { "lervag/vimtex" }

M.lazy = false

function M.init()
  vim.g.vimtex_enabled = 1
  vim.g.vimtex_view_method = "zathura"
  vim.g.vimtex_compiler_method = "latexmk"
  vim.g.vimtex_fold_enabled = 1
  vim.g.vimtex_format_enabled = 1
  vim.o.foldlevel = 2

  vim.g.vimtex_fold_types = {
    markers = {
      text = function(line, level)
        return vim.fn.foldtext()
      end,
    },
  }
end

return M
