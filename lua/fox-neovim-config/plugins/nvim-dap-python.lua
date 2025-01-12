local M = {'mfussenegger/nvim-dap-python' }

M.dependencies = "mfussenegger/nvim-dap"

function M.config()
  require("dap-python").setup(vim.g.python3_host_prog)
end

return M
