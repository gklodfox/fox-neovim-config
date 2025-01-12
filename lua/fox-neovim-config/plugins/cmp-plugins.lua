local M = { "KadoBOT/cmp-plugins" }

function M.opts()
  return {
    files = { "/home/fox/.config/nvim/lua/fox-neovim-config/plugins/" }
  }
end

function M.config(_, opts)
  require("cmp-plugins").setup(opts)
end

return M
