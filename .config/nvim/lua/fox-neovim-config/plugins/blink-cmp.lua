local M = { "saghen/blink.cmp" }

M.dependencies = {
    "rafamadriz/friendly-snippets",
    'folke/lazydev.nvim',
}
M.version = "1.*"
-- M.build = "cargo build --release"

function M.opts()
    return {
        keymap = {
            preset = "super-tab",
        },
        completion = { list = {selection = {preselect = false, auto_insert = true }}, menu = { auto_show = true }, accept = { auto_brackets = { enabled = true }, }, keyword = { range = 'full' }, ghost_text = { enabled = true }, documentation = { auto_show = true, auto_show_delay_ms = 500 } },
        appearance = {
            nerd_font_variant = 'mono'
        },
        sources = {
            default = { "lazydev", "lsp", "path", "snippets", "buffer" },
            providers = {
                lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
            }
        },
        fuzzy = { implementation = "prefer_rust" },
        cmdline = {
            completion = {
                menu = {
                    auto_show = true,
                },
            },
        },
        snippets = { preset = 'luasnip' },
        signature = { enabled = true },
    }
end

function M.config(_, opts)
    require('blink.cmp').setup(opts)
end

return M
