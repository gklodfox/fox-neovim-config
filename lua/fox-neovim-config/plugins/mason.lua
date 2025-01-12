local M = {  "williamboman/mason.nvim" }

local function get_default_servers()
  return {
    "lua_ls",
    "groovyls",
    "marksman",
    "pylsp",
    "jsonls",
    "bashls",
    "clangd",
    "cmake",
    "diagnosticls",
    "dockerls",
    "dotls",
    "yamlls",
    "vimls",
  }
end

M.dependencies = { "williamboman/mason-lspconfig.nvim" }

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

function M.setup(_, opts)
  local mason = require("mason")
  local mason_lspconfig = require("mason-lspconfig")
  local default_servers = get_default_servers()

  mason.setup(opts)
  mason_lspconfig.setup({
    ensure_installed = default_servers,
    automatic_installation = true,
  })
end

return M
