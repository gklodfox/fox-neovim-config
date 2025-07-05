local M = { "mbbill/undotree" }

function M.config()
  vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Undotree" })
end

return M
