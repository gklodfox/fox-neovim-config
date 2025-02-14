return {
    {"nvim-lua/plenary.nvim", lazy = true },
    {"nvim-tree/nvim-web-devicons", enabled = false, optional = true},
    {"folke/neodev.nvim", opts = {}, lazy = false},
    {
        'echasnovski/mini.icons',
        lazy = true,
        opts = {},
        init = function()
            local icons = require('mini.icons')
            package.preload["nvim-tree/nvim-web-devicons"] = function()
                icons.mock_nvim_web_devicons()
                return package.loaded["nvim-web-devicons"]
            end
            icons.tweak_lsp_kind()
        end,
    },
    {"MunifTanjim/nui.nvim", lazy = true},
    {"max397574/better-escape.nvim", lazy = true},
}
