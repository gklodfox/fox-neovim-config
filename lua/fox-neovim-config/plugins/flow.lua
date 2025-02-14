local M = { "0xstepit/flow.nvim" }

M.build = "make extras"
M.lazy = false
M.priority = 1000
M.tag = "v2.0.1"

function M.init()
  vim.opt.termguicolors = true
end

function M.opts()
  return {
      theme = {
        style = "dark",
        contrast = "high",
        transparent = true,
      },
      colors = {
        mode = "light",
        fluo = "pink",
      },
      custom = {
        saturation = 100,
        light = 100,
      },
      ui = {
        borders = "fluo",
      }
  }
end

function M.config(_, opts)
  require("flow").setup(opts)
  vim.cmd("colorscheme flow")
end

return M
