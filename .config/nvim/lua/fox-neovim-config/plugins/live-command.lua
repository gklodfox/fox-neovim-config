local M = { "smjonas/live-command.nvim" }

function M.opts()
    return {
        enable_highlighting = true,
        inline_highlighting = true,
        commands = {
            Norm = { cmd = "norm" },
        },
    }
end

function M.config(_, opts)
    require('live-command').setup(opts)
    vim.cmd("cnoreabbrev norm Norm")
end

return M
