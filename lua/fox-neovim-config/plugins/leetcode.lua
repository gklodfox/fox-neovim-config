local M = { "kawre/leetcode.nvim" }

M.build = ":TSUpdate html"
M.dependencies = {
  "nvim-telescope/telescope.nvim",
  "nvim-lua/plenary.nvim",
  "MunifTanjim/nui.nvim",
}

function M.opts()
  return { lang = "rust" }
end

return M
