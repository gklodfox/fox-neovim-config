local M = { "doxnit/cmp-luasnip-choice" }

M.dependencies = { "L3MON4D3/LuaSnip" }

function M.opts()
  return {
    auto_open = true
  }
end

return M
