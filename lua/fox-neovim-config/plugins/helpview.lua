local M = { "OXY2DEV/helpview.nvim" }

M.lazy = false
M.dependencies = { "echasnovski/mini.icons" }

function M.opts()
  return {
    preview = {
      icon_provider = "mini"
    }
  }
end

return M
