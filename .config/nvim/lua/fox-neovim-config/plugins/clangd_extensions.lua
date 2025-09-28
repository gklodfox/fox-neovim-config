local M = {"p00f/clangd_extensions.nvim"}

function M.opts()
    return {
        ast = {
            role_icons = {
                type = "",
                declaration = "",
                expression = "",
                specifier = "",
                statement = "",
                ["template argument"] = ""
            },
            kind_icons = {
                Compound = "",
                Recovery = "",
                TranslationUnit = "",
                PackExpansion = "",
                TemplateTypeParm = "",
                TemplateTemplateParm = "",
                TemplateParamObject = ""
            },
            highlights = {detail = "Comment"}
        },
        memory_usage = {border = "none"},
        symbol_info = {border = "none"}
    }
end

function M.config(_, opts) require("clangd_extensions").setup(opts) end

return M
