local M = {"lukas-reineke/indent-blankline.nvim"}
M.dependencies = "HiPhish/rainbow-delimiters.nvim"
M.enabled = false
-- M.event = "User FilePost"

local rainbow_highlight = {
    "RainbowRed", "RainbowYellow", "RainbowBlue", "RainbowOrange",
    "RainbowGreen", "RainbowViolet", "RainbowCyan"
}

function M.opts()
    return {
        scope = {highlight = rainbow_highlight},
        exclude = {filetypes = {"dashboard", "help", "NvimTree"}}
    }
end

function M.init()
    local rainbow_delimiters = require("rainbow-delimiters")

    vim.g.rainbow_delimiters = {
        strategy = {
            [""] = rainbow_delimiters.strategy["global"],
            vim = rainbow_delimiters.strategy["local"]
        },
        query = {[""] = "rainbow-delimiters", lua = "rainbow-blocks"},
        priority = {[""] = 110, lua = 210},
        highlight = rainbow_highlight
    }
end

function M.config(_, opts)
    local ibl = require("ibl")
    local hooks = require("ibl.hooks")

    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    end)
    ibl.setup(opts)

    hooks.register(hooks.type.SCOPE_HIGHLIGHT,
                   hooks.builtin.scope_highlight_from_extmark)
end

return M
