local M = { "ThePrimeagen/harpoon" }

M.branch = "harpoon2"
M.dependencies = { "nvim-lua/plenary.nvim" }

function M.config()
  local harpoon = require("harpoon")
  local extensions = require("harpoon.extensions")
  harpoon.setup({})
  harpoon:extend(extensions.builtins.command_on_nav("foo bar"));
  harpoon:extend(extensions.builtins.navigate_with_number());
end

return M
