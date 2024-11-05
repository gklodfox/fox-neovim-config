local M = {  "williamboman/mason.nvim" }

function M.opts()
  return {
    ui = {
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗"
      }
    }
  }

end

return M
