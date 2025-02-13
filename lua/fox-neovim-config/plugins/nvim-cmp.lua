local M = {"hrsh7th/nvim-cmp"}

M.dependencies = {
    "hrsh7th/cmp-buffer", "FelipeLema/cmp-async-path", "hrsh7th/cmp-nvim-lua",
    "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-calc", "mtoohey31/cmp-fish",
    "petertriho/cmp-git", "hrsh7th/cmp-cmdline", "lukas-reineke/cmp-rg",
    "lukas-reineke/cmp-under-comparator",
    "hrsh7th/cmp-nvim-lsp-document-symbol",
    "hrsh7th/cmp-nvim-lsp-signature-help", "L3MON4D3/LuaSnip",
    "windwp/nvim-autopairs", "rafamadriz/friendly-snippets",
    "onsails/lspkind.nvim", "doxnit/cmp-luasnip-choice", "KadoBOT/cmp-plugins",
    "yutkat/cmp-mocword", "saadparwaiz1/cmp_luasnip", "ray-x/cmp-treesitter",
    "williamboman/mason-lspconfig.nvim", "chrisgrieser/cmp_yanky",
    "quangnguyen30192/cmp-nvim-tags", "delphinus/cmp-ctags"
}
function M.opts()
    local cmp = require("cmp")
    local select_opts = {behavior = cmp.SelectBehavior.Select}
    return {
        experimental = {ghost_text = true},
        completion = {completeopt = "menu,menuone,noinsert"},
        snippet = {
            expand = function(args)
                require("luasnip").lsp_expand(args.body)
            end
        },
        mapping = {
            ['<Up>'] = cmp.mapping.select_prev_item(select_opts),
            ['<Down>'] = cmp.mapping.select_next_item(select_opts),

            ['<C-p>'] = cmp.mapping.select_prev_item(select_opts),
            ['<C-n>'] = cmp.mapping.select_next_item(select_opts),

            ['<C-u>'] = cmp.mapping.scroll_docs(-4),
            ['<C-d>'] = cmp.mapping.scroll_docs(4),

            ['<C-e>'] = cmp.mapping.abort(),
            ['<C-y>'] = cmp.mapping.confirm({select = true}),
            ['<CR>'] = cmp.mapping.confirm({select = false}),

            ['<C-f>'] = cmp.mapping(function(fallback)
                if require("luasnip").jumpable(1) then
                    require("luasnip").jump(1)
                else
                    fallback()
                end
            end, {'i', 's'}),

            ['<C-b>'] = cmp.mapping(function(fallback)
                if require("luasnip").jumpable(-1) then
                    require("luasnip").jump(-1)
                else
                    fallback()
                end
            end, {'i', 's'}),

            ['<Tab>'] = cmp.mapping(function(fallback)
                local col = vim.fn.col('.') - 1

                if cmp.visible() then
                    cmp.select_next_item(select_opts)
                elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
                    fallback()
                else
                    cmp.complete()
                end
            end, {'i', 's'}),

            ['<S-Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item(select_opts)
                else
                    fallback()
                end
            end, {'i', 's'})
        },
        sources = require("cmp").config.sources({
            {name = "nvim_lsp"}, {name = "render-markdown"}, {
                name = "luasnip",
                option = {show_autosnippets = true, use_show_condition = true}
            }, {name = "luasnip_choice"}, {name = "async_path"},
            {name = "codeium"}, {name = "nvim_lua"},
            {name = "nvim_lsp_signature_help"},
            {name = "nvim_lsp_document_symbol"}, {name = "plugins"},
            {name = "calc"}, {name = "rg"}, {name = "buffer"},
            {name = "treesitter"}, {name = "cmp_yanky"}
        })
    }
end
function M.config(_, opts)
    local cmp = require("cmp")
    cmp.setup(opts)
    require("nvim-autopairs").setup()
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")

    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
    --
    -- cmp_autopairs.lisp[#cmp_autopairs.lisp + 1] = "racket"
    -- local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    -- require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
end

return M
