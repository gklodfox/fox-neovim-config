local M = { 'ray-x/lsp_signature.nvim' }

M.event = "InsertEnter"

function M.init()
  vim.keymap.set({ 'n' }, '<Leader>k', function()
    vim.lsp.buf.signature_help()
  end, { silent = true, noremap = true, desc = 'toggle signature' })
end

function M.opts()
  return {
    bind = true,
    handler_opts = {
      border = "rounded"
    }
  }
end

return M
