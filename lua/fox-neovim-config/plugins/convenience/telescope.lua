local M = { "nvim-telescope/telescope.nvim" }

M.event = "VimEnter"
M.dependencies = {
    "nvim-lua/plenary.nvim",
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
            return vim.fn.executable("make") == 1
        end,
    }
}
M.opts = require("fox-neovim-config.plugins.configs.convenience.telescope")

function M.config(_, opts)
    require("telescope").setup(opts)

    pcall(require("telescope").load_extension, "fzf")
    pcall(require("telescope").load_extension, "ui-select")
    
end


return M
