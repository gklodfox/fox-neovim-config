local M = { "nvim-tree/nvim-tree.lua" }

M.cmd = { "NvimTreeToggle", "NvimTreeFocus" }

function M.opts()
  return {
    sort = {
      sorter = "case_sensitive",
    },
    view = {
      width = 30,
    },
    renderer = {
      group_empty = true,
    }
  }
end

return M
