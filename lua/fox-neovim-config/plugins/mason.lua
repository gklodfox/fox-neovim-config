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

function M.config(_, opts)
  local mason = require("mason")
  mason.setup(opts)
  vim.api.nvim_create_user_command("MasonUpgrade", function()
    local registry = require("mason-registry")
    registry.refresh()
    registry.update()
    local packages = registry.get_all_packages()
    for _, pkg in ipairs(packages) do
      if pkg:is_installed() then
        pkg:install()
      end
    end
    vim.cmd("doautocmd User MasonUpgradeComplete")
  end, { force = true })
end

return M
