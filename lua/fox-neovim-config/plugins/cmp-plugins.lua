local M = { "KadoBOT/cmp-plugins" }

function M.opts()
  return {
    files = { ".*\\.lua", "/home/fox/.config/nvim/lua/fox-neovim-config/plugins/.*\\.lua", vim.env.VIMRUNTIME }
  }
end

function M.config(_, opts)
  require("cmp-plugins").setup(opts)
end

return M
