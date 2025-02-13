local M = { "KadoBOT/cmp-plugins" }

function M.opts()
  return {
    files = { ".*\\.lua" }
  }
end

function M.config(_, opts)
  require("cmp-plugins").setup(opts)
end

return M
