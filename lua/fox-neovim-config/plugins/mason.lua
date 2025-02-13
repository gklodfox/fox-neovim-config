local M = {  "williamboman/mason.nvim" }

function M.opts()
  return {
    ui = {
      border = "rounded",
      icons = {
        package_installed = "✓",
        package_pending = "~",
        package_uninstalled = "✗"
      }
    },
    log_level = vim.log.levels.INFO,
    max_concurrent_installers = 4,
  }
end

return M
