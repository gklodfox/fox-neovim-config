local M = { "nvim-tree/nvim-tree.lua" }

M.cmd = { "NvimTreeToggle", "NvimTreeFocus" }

function M.opts()
  return {
    respect_buf_cwd = true,
    sync_root_with_cwd = true,
    hijack_cursor = true,
    sort = {
      sorter = "case_sensitive",
    },
    view = {
      width = 90,
      side = "right",
      centralize_selection = true,
      float = {
        enable = true,
        quit_on_focus_loss = true,
        open_win_config = {
          relative = "editor",
          border = "rounded",
          width = 69,
          height = 100,
          row = 1,
          col = math.floor(vim.opt.columns:get() * 0.7667),
        }
      }
    },
  }
end

function M.config(_, opts)
  require("nvim-tree").setup(opts)
end

return M
