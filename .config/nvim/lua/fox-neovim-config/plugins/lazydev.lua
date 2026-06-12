--- @type LazyPluginSpec
local M = { 'folke/lazydev.nvim' }

M.opts = {
    library = {
    { path = "snacks.nvim", words = { "Snacks" } },
  },
}

return M
