local M = {"xiyaowong/nvim-transparent"}

M.enabled = false

function M.opts()
    return {
        groups = {
            'Normal', 'NormalNC', 'Comment', 'Constant', 'Special',
            'Identifier', 'Statement', 'PreProc', 'Type', 'Underlined', 'Todo',
            'String', 'Function', 'Conditional', 'Repeat', 'Operator',
            'Structure', 'LineNr', 'NonText', 'EndOfBuffer', 'SignColumn'
        },
        -- table: additional groups that should be cleared
        extra_groups = {"NormalFloat", "FloatBorder", "LspSignatureActiveParameter"},
        -- table: groups you don't want to clear
        exclude_groups = {
            'CursorLine', 'CursorLineNr', 'StatusLine', 'StatusLineNC',
            "NormalFloat", "FloatBorder", "LspSignatureActiveParameter"
        },
        -- function: code to be executed after highlight groups are cleared
        -- Also the user event "TransparentClear" will be triggered
        on_clear = function()
            vim.api.nvim_set_hl(0, 'CursorLine', {bg = "#460D33", bold = true})
        end
    }
end
function M.config(_, opts)
    require("transparent").setup(opts)
end

return M
