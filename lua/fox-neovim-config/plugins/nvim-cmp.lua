local M = {"hrsh7th/nvim-cmp"}

M.event = {"InsertEnter"}
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
    "zjp-CN/nvim-cmp-lsp-rs",
    "quangnguyen30192/cmp-nvim-tags", "delphinus/cmp-ctags"
}

function M.opts()
    local comparators = require("cmp_lsp_rs").comparators
    local compare = require("cmp").config.compare

    return {
        experimental = {
            ghost_text = true,
        },
        snippet = {
            expand = function(args)
                require("luasnip").lsp_expand(args.body)
            end
        },
        sorting = {
            comparators = {
                compare.exact,
                compare.score,
                comparators.inherent_import_inscope,
                comparators.inscope_inherent_import,
                comparators.sort_by_label_but_underscore_last,
            }
        },
    }
end
function M.config(_, opts)
    local cmp = require("cmp")

    cmp.setup({
        mapping = cmp.mapping.preset.insert({
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<CR>"] = cmp.mapping.confirm({behavior = cmp.ConfirmBehavior.Replace, select = true})
        }),
        sources = cmp.config.sources({
            {name = "nvim_lsp"},
            -- {name = "nvim-cmp-lsp-rs"},
            {name = "cmp_ai"},
            {name = "luasnip", option = {show_autosnippets = true, use_show_condition = true}},
            {name = "luasnip_choice"},
            {name = "async_path"},
            {name = "codeium"},
            {name = "nvim_lua"},
            {name = "nvim_lsp_signature_help"},
            {name = "nvim_lsp_document_symbol"},
            {name = "plugins"},
            {name = "calc"},
            {name = "rg"},
            {name = "buffer"},
            {name = "treesitter"},
            {name = "cmp_yanky"},
      }),
    })
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end

return M
