local M = { "ThePrimeagen/harpoon" }

M.branch = "harpoon2"
M.dependencies = { "nvim-lua/plenary.nvim" }
M.opts = {}

function M.config(_, opts)
  -- local harpoon = require("harpoon")
  -- local extensions = require("harpoon.extensions")
  require("harpoon").setup(opts)
  -- harpoon:extend(extensions.builtins.command_on_nav("foo bar"));
  -- harpoon:extend(extensions.builtins.navigate_with_number());
end


return M
