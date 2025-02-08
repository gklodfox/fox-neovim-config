local M = { "xiyaowong/nvim-transparent" }

M.lazy = false

function M.opts()
  return {
    groups = {
      'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
      'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
      'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
      'SignColumn',
      'EndOfBuffer',
    },
    -- table: additional groups that should be cleared
    extra_groups = {},
    -- table: groups you don't want to clear
    exclude_groups = {'CursorLine', 'CursorLineNr', 'StatusLine', 'StatusLineNC',},
    -- function: code to be executed after highlight groups are cleared
    -- Also the user event "TransparentClear" will be triggered
    on_clear = function()
      vim.api.nvim_set_hl(0, 'CursorLine', {bg="#460D33", bold=true})
    end,
  }
end

return M
