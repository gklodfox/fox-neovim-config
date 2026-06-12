local M = {"stevearc/conform.nvim"}
M.cmd = { "ConformInfo" }
M.keys = {
    {
        "<leader>F",
        function()
            require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        mode = "",
        desc = "[F]ormat buffer",
    },
}
M.opts = {}

return M

