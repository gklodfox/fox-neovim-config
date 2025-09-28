local M = {"akinsho/toggleterm.nvim"}

M.event = "VeryLazy"
M.cmd = "ToggleTerm"
M.version = "*"

function M.opts()
    return {
        size = 10,
        open_mapping = [[<F12>]],
        shading_factor = 2,
        direction = "float",
        float_opts = {
            border = "rounded",
            winblend = 2,
            highlights = {
                NormalFloat = {link = 'Normal'}
                --   border = "Normal",
                --   background = "Normal",
            }
        }
    }
end

function M.config(_, opts)
    require("toggleterm").setup(opts)
    -- "vim.cmd("autocmd! TermOpen term://* lua require('toggleterm').start()")
end

return M
