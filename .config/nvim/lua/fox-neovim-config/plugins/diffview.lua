local M = {'sindrets/diffview.nvim'}

function M.opts() return {enhanced_diff_hl = false} end

function M.config(_, opts) require("diffview").setup(opts) end

return M
