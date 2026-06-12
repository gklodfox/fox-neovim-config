local M = { "saghen/blink.cmp" }

M.dependencies = {
    "rafamadriz/friendly-snippets",
}
M.version = "1.*"
M.opts_extend = { "sources.default" }

function M.opts()
    return {
        keymap = { preset = "enter", },
        appearance = { nerd_font_variant = 'mono' },
        completion = {
            list = {
                selection = {
                    preselect = true,
                    auto_insert = true
                }
            },
            documentation = { auto_show = true, auto_show_delay_ms = 3000 }
        },
        sources = {
            default = { "lsp", "path", "snippets", "buffer" },
        },
        fuzzy = { implementation = "prefer_rust_with_warning" }
    }
end

return M
