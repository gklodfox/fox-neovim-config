local M = { "nvim-treesitter/nvim-treesitter-context" }

function M.opts()
    return {
        enable = true,        -- Enable this plugin (Can be enabled/disabled later via commands)
        max_lines = 0,        -- How many lines the window should span. Values <= 0 mean no limit.
        min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
        line_numbers = true,
        multiline_threshold = 20, -- Maximum number of lines to show for a single context
        trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
        mode = 'cursor',      -- Line used to calculate context. Choices: 'cursor', 'topline'
        separator = nil,
        zindex = 20,          -- The Z-index of the context window
    }
end

function M.config(_, opts)
    require("treesitter-context").setup(opts)
end

return M
