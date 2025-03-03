local M = { "kawre/leetcode.nvim" }

M.build = ":TSUpdate html"
M.event = "VimEnter"

M.dependencies = {
  -- "nvim-telescope/telescope.nvim",
  "nvim-lua/plenary.nvim",
  "MunifTanjim/nui.nvim",
}

function M.opts()
  return { lang = "rust" }
end

function M.config(_, opts)
  require("leetcode").setup(opts)
end

return M
