local M = {"doxnit/cmp-luasnip-choice"}

M.dependencies = {"L3MON4D3/LuaSnip"}
M.enabled = false

function M.opts() return {auto_open = true} end

function M.config(_, opts) require("cmp_luasnip_choice").setup(opts) end

return M
