local M = {"kawre/leetcode.nvim"}

M.dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim"
}

function M.opts()
    return {
        lang = "cpp"
    }
end

function M.config(_, opts) require("leetcode").setup(opts) end

return M
