local M = { "OXY2DEV/helpview.nvim" }

M.dependencies = { "echasnovski/mini.icons" }

function M.opts()
  return {
    preview = {
      icon_provider = "mini",
    },
  }
end

function M.config(_, opts)
  require("helpview").setup(opts)
end

return M
