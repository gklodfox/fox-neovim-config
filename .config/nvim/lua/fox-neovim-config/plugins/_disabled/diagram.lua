local M = {"3rd/diagram.nvim"}

M.dependencies = "3rd/image.nvim"
M.enabled = false

function M.opts()
    return {
        integrations = {
            require("diagram.integrations.markdown"),
            require("diagram.integrations.neorg")
        },
        renderer_options = {
            mermaid = {theme = "forest"},
            plantuml = {charset = "utf-8"},
            d2 = {theme_id = 1},
            gnuplot = {theme = "dark", size = "800,600"}
        }
    }
end

function M.config(_, opts) require("diagram").setup(opts) end

return M
