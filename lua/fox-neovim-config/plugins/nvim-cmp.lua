local M = {"hrsh7th/nvim-cmp"}

M.dependencies = {
    "hrsh7th/cmp-buffer", "FelipeLema/cmp-async-path", "hrsh7th/cmp-nvim-lua",
    "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-calc", "mtoohey31/cmp-fish",
    "petertriho/cmp-git", "hrsh7th/cmp-cmdline", "lukas-reineke/cmp-rg",
    "hrsh7th/cmp-nvim-lsp-document-symbol",
    "hrsh7th/cmp-nvim-lsp-signature-help", "L3MON4D3/LuaSnip",
    "rafamadriz/friendly-snippets", "onsails/lspkind.nvim",
    "doxnit/cmp-luasnip-choice", "KadoBOT/cmp-plugins",
    "saadparwaiz1/cmp_luasnip", "ray-x/cmp-treesitter", "windwp/nvim-autopairs",
    "williamboman/mason-lspconfig.nvim", {
        "garymjr/nvim-snippets",
        opts = {friendly_snippets = true},
        dependencies = {"rafamadriz/friendly-snippets"}
    }
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

    local npairs = require("nvim-autopairs.completion.cmp")

    cmp.event:on("confirm_done",npairs.on_confirm_done())

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
        snippet = {expand = function(args) luasnip.lsp_expand(args.body) end},
        mapping = cmp.mapping.preset.insert({
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<Down>"] = cmp.mapping.select_next_item(insert_opts),
            ["<Up>"] = cmp.mapping.select_prev_item(insert_opts),
            ["<C-Right>"] = cmp.mapping.complete(),
            ['<C-Left>'] = cmp.mapping.abort(),
            ["<CR>"] = cmp.mapping.confirm(select_opts),
            ["<S-CR>"] = cmp.mapping.confirm(select_opts), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
            -- ['<Tab>'] = function(fallback)
            --     if cmp.visible() then
            --         cmp.select_next_item()
            --     else
            --         fallback()
            --     end
            -- end
        }),
        formatting = {
            format = function(entry, item)
                local icons = LazyVim.config.icons.kinds
                if icons[item.kind] then
                    item.kind = icons[item.kind] .. item.kind
                end

                local widths = {
                    abbr = vim.g.cmp_widths and vim.g.cmp_widths.abbr or 40,
                    menu = vim.g.cmp_widths and vim.g.cmp_widths.menu or 30
                }

                for key, width in pairs(widths) do
                    if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
                        item[key] =
                            vim.fn.strcharpart(item[key], 0, width - 1) .. "…"
                    end
                end

                return item
            end
        },
        sources = cmp.config.sources({
            {name = "nvim_lsp"}, {name = "render-markdown"}, {name = "luasnip"},
            {name = "async_path"}, {name = "path"}, {name = "nvim_lua"},
            {name = "nvim_lsp_signature_help"}, {name = "snippets"},
            {name = "nvim_lsp_document_symbol"}, {name = "plugins"},
            {name = "calc"}, {name = "rg"}, {name = "treesitter"}
        }, {{name = "buffer"}}),
        experimental = {
            ghost_text = vim.g.ai_cmp and {hl_group = "CmpGhostText"} or false
        },
        sorting = defaults.sorting
    }
end

return M
