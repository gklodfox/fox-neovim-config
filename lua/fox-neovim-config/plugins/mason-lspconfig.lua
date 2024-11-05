local M = { "williamboman/mason-lspconfig.nvim" }

function M.opts()
  return {
    automatic_installation = true,
    ensure_installed = {
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
  }
end

return M
