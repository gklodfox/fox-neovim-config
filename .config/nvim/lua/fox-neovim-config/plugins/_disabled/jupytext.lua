local M = {"GCBallesteros/jupytext.nvim"}

M.lazy = false
M.enabled = false

function M.opts()
    return {
        style = "hydrogen",
        output_extension = "auto", -- Default extension. Don't change unless you know what you are doing
        force_ft = nil, -- Default filetype. Don't change unless you know what you are doing
        custom_language_formatting = {},
        python = {
            extension = "qmd",
            style = "quarto",
            force_ft = "quarto" -- you can set whatever filetype you want here
        }
    }
end

function M.config(_, opts) require("jupytext").setup(opts) end

return M
