local M = { "nvim-tree/nvim-tree.lua" }

M.cmd = { "NvimTreeToggle", "NvimTreeFocus" }

function M.opts()
  return {
    respect_buf_cwd = true,
    sort = {
      sorter = "case_sensitive",
    },
    view = {
      width = 70,
      side = "right",
      centralize_selection = true,
      float = {
        enable = true,
        quit_on_focus_loss = true,
        open_win_config = {
          relative = "editor",
          border = "rounded",
          width = 12,
          height = 3,
          row = 1,
          col = vim.opt.columns:get()-12,
        }
      }
    },
    renderer = {
      group_empty = true,
    },
    filters = {
      dotfiles = true,
    },
  }
end

return M
