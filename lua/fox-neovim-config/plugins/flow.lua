local M = { "0xstepit/flow.nvim" }
M.build = "make extras"

function M.opts()
  return {
    lazy = false,
    priority = 1000,
    tag = "vX.0.0",
    opts = {
      theme = {
        style = "dark",
        contrast = "high",
        transparent = true,
      },
      colors = {
        mode = "dark",
        fluo = "pink",
      },
      ui = {
        borders = "fluo",
      }
    },
  }
end

function M.config(_, opts)
  require("flow").setup(opts)
  vim.cmd("colorscheme flow")
end

return M
