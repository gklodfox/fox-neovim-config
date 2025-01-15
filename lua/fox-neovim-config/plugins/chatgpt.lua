local M = {"jackMort/ChatGPT.nvim"}

M.event = "VeryLazy"
M.dependencies = {
  "MunifTanjim/nui.nvim",
  "nvim-lua/plenary.nvim",
  "folke/trouble.nvim", -- optional
  "nvim-telescope/telescope.nvim"
}

function M.config(_, opts)
  require("chatgpt").setup(opts)
end

return M
