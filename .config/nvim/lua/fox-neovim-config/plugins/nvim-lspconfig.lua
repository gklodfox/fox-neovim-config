local M = { 'neovim/nvim-lspconfig' }
M.dependencies = { 'mason-org/mason.nvim', opts = {} }

function M.init()
    vim.diagnostic.config({
        virtual_text = { enabled = true},
        virtual_lines = { enabled = false},
        float = {
            source = true,
            header = "Diagnostics:",
            prefix = " ",
            border = "single",
            max_height = 10,
            max_width = 130,
            close_events = { "CursorMoved", "BufLeave", "WinLeave" },
        },
        update_in_insert = true,
        underline = { severity = { vim.diagnostic.severity.WARN, vim.diagnostic.severity.ERROR, vim.diagnostic.severity.HINT, vim.diagnostic.severity.INFO } },
        severity_sort = true,
    })
    vim.api.nvim_create_autocmd("CursorHold", {
        pattern = "*",
        callback = function()
            if #vim.diagnostic.get(0) == 0 then
                return
            end

            if not vim.b.diagnostics_pos then
                vim.b.diagnostics_pos = { nil, nil }
            end

            local cursor_pos = vim.api.nvim_win_get_cursor(0)

            if not vim.deep_equal(cursor_pos, vim.b.diagnostics_pos) then
                vim.diagnostic.open_float {}
            end

            vim.b.diagnostics_pos = cursor_pos
        end,
    })
end

return M
