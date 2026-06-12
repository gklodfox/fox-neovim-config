local M = {"3rd/diagram.nvim"}

M.enabled = false

M.dependencies = {{"snacks.nvim"}}

function M.opts()
    return {
        integrations = {
            require("diagram.integrations.markdown"),
            require("diagram.integrations.neorg")
        },
        renderer_options = {
            mermaid = {theme = "dark"},
            plantuml = {charset = "utf-8"},
            d2 = {theme_id = 1},
            gnuplot = {theme = "dark", size = "800,600"}
        }
    }
end

return M
