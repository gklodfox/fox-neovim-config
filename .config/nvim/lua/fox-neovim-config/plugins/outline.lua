local M = {"hedyhli/outline.nvim"}

M.dependencies = {
    "epheien/outline-treesitter-provider.nvim",
    "msr1k/outline-asciidoc-provider.nvim", "onsails/lspkind.nvim"
}

function M.opts()
    return {
        focus_on_open = false,
        center_on_jump = false,
        auto_jump = true,
        auto_close = true,
        providers = {
            priority = {
                "treesitter", "lsp", 'markdown', 'norg', 'man', 'asciidoc'
            }
        },
        symbol_folding = {auto_unfold = {only = 4}},
        outline_items = {
            show_symbol_lineno = true,
            show_symbol_details = true,
            show_icon = true,
            show_relative_number = true,
            show_fold_markers = true,
            show_cursorline = true,
            hide_cursor = true
        },
        preview_window = {auto_preview = true, winhl = 'NormalFloat:'},
        symbols = {icon_source = 'lspkind'}
    }
end

function M.config(_, opts)
    -- Example mapping to toggle outline
    vim.keymap.set("n", "<leader>o", "<cmd>Outline<CR>",
                   {desc = "Toggle Outline"})
    require("outline").setup(opts)
end

return M
