local M = {"neovim/nvim-lspconfig"}

M.dependencies = {"hrsh7th/cmp-nvim-lsp", "williamboman/mason-lspconfig.nvim"}
M.event = "VimEnter"
function M.config(_, opts)
    local signs = {
        {name = "DiagnosticSignError", text = "✘'"},
        {name = "DiagnosticSignWarn", text = "▲"},
        {name = "DiagnosticSignHint", text = "⚑"},
        {name = "DiagnosticSignInfo", text = ""}
    }
    vim.diagnostic.config({
        virtual_text = true,
        signs = {active = signs},
        update_in_insert = true,
        underline = true,
        severity_sort = true
    })
    for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name,
                           {texthl = sign.name, text = sign.text, numhl = ""})
    end
end

return M

