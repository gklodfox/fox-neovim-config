local M = {"hrsh7th/nvim-cmp"}

M.dependencies = {
    "hrsh7th/cmp-buffer", "FelipeLema/cmp-async-path", "hrsh7th/cmp-nvim-lua",
    "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-calc", "mtoohey31/cmp-fish",
    "petertriho/cmp-git", "hrsh7th/cmp-cmdline", "lukas-reineke/cmp-rg",
    "hrsh7th/cmp-nvim-lsp-document-symbol",
    "hrsh7th/cmp-nvim-lsp-signature-help", "L3MON4D3/LuaSnip",
    "rafamadriz/friendly-snippets",
    "onsails/lspkind.nvim", "doxnit/cmp-luasnip-choice", "KadoBOT/cmp-plugins",
    "saadparwaiz1/cmp_luasnip", "ray-x/cmp-treesitter",
    "williamboman/mason-lspconfig.nvim"
}
M.event = "InsertEnter"
function M.opts()
    vim.api.nvim_set_hl(0, "CmpGhostText", {link = "Comment", default = true})
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local defaults = require("cmp.config.default")()
    local insert_opts = {behavior = cmp.SelectBehavior.Insert}
    local select_opts = {behavior = cmp.SelectBehavior.Replace, select = true}
    local auto_select = true
    return {
        auto_brackets = {
            "python", "lua", "rust", "fish", "sh", "bash", "json", "markdown",
            "yaml", "toml", "html", "css"
        },
        completion = {
            completeopt = "menu,menuone,noinsert" ..
                (auto_select and "" or ",noselect")
        },
        preselect = auto_select and cmp.PreselectMode.Item or
            cmp.PreselectMode.None,
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end
        },
        mapping = cmp.mapping.preset.insert({
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-n>"] = cmp.mapping.select_next_item(insert_opts),
            ["<C-p>"] = cmp.mapping.select_prev_item(insert_opts),
            ["<C-S-CR>"] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.abort(),
            ["<CR>"] = cmp.confirm({select = auto_select}),
            ["<C-y>"] = cmp.confirm({select = true}),
            ["<S-CR>"] = cmp.confirm(select_opts), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
            ['<Tab>'] = function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                else
                    fallback()
                end
            end
        }),
        sources = cmp.config.sources({
            {name = "nvim_lsp"}, {name = "render-markdown"}, {name = "luasnip"},
            {name = "async_path"}, {name = "path"}, {name = "nvim_lua"},
            {name = "nvim_lsp_signature_help"},
            {name = "nvim_lsp_document_symbol"}, {name = "plugins"},
            {name = "calc"}, {name = "rg"}, {name = "treesitter"}
        }, {{name = "buffer"}}),
        experimental = {ghost_text = vim.g.ai_cmp and {hl_group = "CmpGhostText"} or false},
        sorting = defaults.sorting
      }
end
function M.config(_, opts)
    local cmp = require("cmp")
    -- local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    --
    -- cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    cmp.setup(opts)
    --
    -- cmp_autopairs.lisp[#cmp_autopairs.lisp + 1] = "racket"
    -- local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    -- require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
end

return M
