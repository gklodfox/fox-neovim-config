local M = { "j-hui/fidget.nvim" }

function M.opts()
  return {
    progress = {
      ignore_done_already = true,
      ignore_empty_message = true,
      display = {
        render_limit = 32,
      },
    },
    notification = {
      poll_rate = 10,
      history_size = 8192,
      override_vim_notify = true,
      window = {
        winblend = 100
      },
    },
    integration = {
      ["nvim-tree"] = {
        enable = true,
      }
    }
  }
end

return M
