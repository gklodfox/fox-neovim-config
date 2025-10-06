local M = {'quarto-dev/quarto-nvim'}

M.dependencies = {"jmbuhr/otter.nvim", "nvim-treesitter/nvim-treesitter"}
M.ft = {"quarto", "markdown"}
M.enabled = false

function M.opts()
    return {
        debug = false,
        closePreviewOnExit = true,
        lspFeatures = {
            enabled = true,
            chunks = "curly",
            languages = {"r", "python", "julia", "bash", "html"},
            diagnostics = {enabled = true, triggers = {"BufWritePost"}},
            completion = {enabled = true}
        },
        codeRunner = {
            enabled = true,
            default_method = "slime", -- "molten", "slime", "iron" or <function>
            ft_runners = {}, -- filetype to runner, ie. `{ python = "molten" }`.
            -- Takes precedence over `default_method`
            never_run = {'yaml'} -- filetypes which are never sent to a code runner
        }
    }
end

function M.config(_, opts) require('quarto').setup(opts) end

return M
