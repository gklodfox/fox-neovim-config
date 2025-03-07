local M = { "lukas-reineke/indent-blankline.nvim" }
M.dependencies = "HiPhish/rainbow-delimiters.nvim"
-- M.event = "User FilePost"

local rainbow_highlight = {
  "RainbowRed",
  "RainbowYellow",
  "RainbowBlue",
  "RainbowOrange",
  "RainbowGreen",
  "RainbowViolet",
  "RainbowCyan",
}

function M.opts()
  return {
    scope = { highlight = rainbow_highlight },
    exclude = { filetypes = { "dashboard", "help", "NvimTree" } },
  }
end

function M.init()
  local rainbow_delimiters = require("rainbow-delimiters")

  vim.g.rainbow_delimiters = {
    strategy = {
      [""] = rainbow_delimiters.strategy["global"],
      vim = rainbow_delimiters.strategy["local"],
    },
    query = {
      [""] = "rainbow-delimiters",
      lua = "rainbow-blocks",
    },
    priority = {
      [""] = 110,
      lua = 210,
    },
    highlight = rainbow_highlight,
  }
end

function M.config(_, opts)
  local ibl = require("ibl")
  local hooks = require("ibl.hooks")

  hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
    vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
    vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
    vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
    vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
    vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
    vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
  end)
  ibl.setup(opts)

  hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
end

return M
