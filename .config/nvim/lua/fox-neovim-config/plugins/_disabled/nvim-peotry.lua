local M = {"karloskar/poetry-nvim"}

M.enabled = false

function M.config() require("poetry-nvim").setup() end

return M
