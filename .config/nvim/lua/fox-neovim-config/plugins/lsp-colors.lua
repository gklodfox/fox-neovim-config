local M = {"folke/lsp-colors.nvim"}

function M.opts()
    return {
        Error = "#FFEB55",
        Warning = "#EE66A6",
        Information = "#D91656",
        Hint = "#640D5F"
    }
end

function M.config(_, opts) require("lsp-colors").setup(opts) end

return M
