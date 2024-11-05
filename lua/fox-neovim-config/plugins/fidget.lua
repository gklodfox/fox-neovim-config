local M = { "j-hui/fidget.nvim" }

function M.opts()
  return {
    notification = {
      poll_rate = 10,
      history_size = 512,
      override_vim_notify = true,
      window = {
        winblend = 0
      }
    },
  }
end

return M
