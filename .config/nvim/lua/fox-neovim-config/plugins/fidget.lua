local M = { "j-hui/fidget.nvim" }

M.lazy = false
function M.opts()
  return {
    progress = {
      ignore_done_already = true,
      ignore_empty_message = true,
      display = {
        render_limit = 5
      }
    },
    notification = {
      poll_rate = 10,
      history_size = 8192,
      override_vim_notify = true,
      window = {
        -- winblend = 0,
        avoid = { "NvimTree" }
      }
    }
  }
end

return M
