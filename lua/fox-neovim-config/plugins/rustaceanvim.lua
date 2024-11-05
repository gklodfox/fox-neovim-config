local M = { "mrcjkb/rustaceanvim" }

M.version = "^5"
M.lazy = false

function M.init()
  vim.g.rustaceanvim = function()
    return {
      -- Plugin configuration
      tools = {},
      -- LSP configuration
      server = {
        on_attach = function(client, bufnr)
          -- you can also put keymaps in here
        end,
        default_settings = {
          -- rust-analyzer language server configuration
          ['rust-analyzer'] = {},
        },
      },
      -- DAP configuration
      dap = {},
    }
  end
end

return M
