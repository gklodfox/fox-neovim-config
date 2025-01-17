local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and
               vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col,
                                                                          col)
                   :match("%s") == nil
end
local M = {"hrsh7th/nvim-cmp"}

M.event = {"InsertEnter", "CmdlineEnter"}
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
        completion = {completeopt = "menu,menuone,noinsert"},
        window = {
            completion = {border = "rounded", scrollbar = false},
            documentation = {border = "rounded", scrollbar = false}
        },
        performance = {debounce = 0, throttle = 0},
        experimental = {
            ghost_text = true,
        },
        snippet = {
            expand = function(args)
                require("luasnip").lsp_expand(args.body)
            end
        },
        formatting = {
            -- fields = { "kind", "abbr", "menu" },
            format = require("lspkind").cmp_format({
                menu = {
                    nvim_lsp = "[LSP]",
                    nvim_lua = "[NvLua]",
                    luasnip = "[LuaSnip]",
                    async_path = "[Path]",
                    calc = "[Calc]",
                    treesitter = "[TS]",
                    cmp_lsp_rs = "[CmpRS]",
                    nvim_lsp_signature_help = "[LspSig]",
                    nvim_lsp_document_symbol = "[LspSym]",
                    rg = "[Rg]",
                    buffer = "[Buffer]",
                    plugins = "[Plugins]",
                    fish = "[Fish]",
                    -- cmp_ai = "[AI]",
                    ctags = "[Ctags]",
                    tags = "[Tags]",
                    -- codeium = "[Codeium]"
                }
            })
        },
        sorting = {
            comparators = {
                compare.exact,
                compare.score,
                -- comparators.inherent_import_inscope,
                comparators.inscope_inherent_import,
                comparators.sort_by_label_but_underscore_last,

            }
        },
        sources = {
            {name = "nvim_lsp", priority = 100},
            {name = "nvim-cmp-lsp-rs", priority = 100},
            -- {name = "cmp_ai", priority = 100},
            {name = "luasnip", priority = 85, option = { show_autosnippets = true, use_show_condition = true }},
            {name = "luasnip_choice", priority = 90},
            {name = "async_path", priority = 95},
            -- {name = "codeium", priority = 70},
            {name = "nvim_lua", priority = 90},
            {name = "nvim_lsp_signature_help", priority = 80},
            {name = "nvim_lsp_document_symbol", priority = 80},
            {name = "plugins", priority = 85}, {name = "git", priority = 85},
            {name = "calc", priority = 50}, {name = "rg", priority = 95},
            {name = "tags", priority = 60}, {name = "ctags", priority = 60},
            {name = "buffer", priority = 75},
            {name = "cmp_yanky", priority = 80},
            {name = "treesitter", priority = 30},
            {name = "mocword", priority = 60},
            {
              name = "fish",
              priority = 10,
              group_index = 9,
              entry_filter = function()
                if vim.bo.filetype ~= "gitcommit" then
                  return false
                end
                return true
              end,
            },
            {
              name = "git",
              entry_filter = function()
                if vim.bo.filetype ~= "gitcommit" then
                  return false
                end
                return true
              end,
              priority = 40,
              group_index = 5,
            },
        }
    }
end
function M.config(_, opts)
    local cmp = require("cmp")

    cmp.setup(opts)
    cmp.mapping.preset.insert({
      ['<CR>'] = cmp.mapping.confirm({
        select = false,
        behavior = cmp.ConfirmBehavior.Replace
      }),
      -- ['<S-Tab>'] = cmp.mapping(function(fallback)
      --     if cmp.visible() then
      --         if #cmp.get_entries() == 1 then
      --             cmp.confirm({select = true})
      --         else
      --             cmp.select_next_item()
      --         end
      --     elseif require("luasnip").can_expand_or_advance() then
      --         require("luasnip").expand_or_advance()
      --     elseif has_words_before() then
      --         cmp.complete()
      --         if #cmp.get_entries() == 1 then
      --             cmp.confirm({select = true})
      --         end
      --     else
      --         fallback()
      --     end
      -- end, {"i", "s"})
    })
    cmp.setup.filetype({"gitcommit", "markdown"}, {
        sources = require("cmp").config.sources({
            -- {name = "codeium", priority = 70},
            {name = "nvim_lsp", priority = 100},
            {name = "cmp_lsp_rs", priority = 100},
            {name = "luasnip", priority = 85},
            {name = "luasnip_choice", priority = 90},
            {name = "nvim_lsp_signature_help", priority = 80},
            {name = "nvim_lsp_document_symbol", priority = 80},
            {name = "rg", priority = 70}, {name = "async_path", priority = 100}
        }, {
            {name = "buffer", priority = 50}, {name = "spell", priority = 40},
            {name = "calc", priority = 50},
            {name = "treesitter", priority = 30},
            {name = "mocword", priority = 60}, {name = "git", priority = 65},
            {name = "cmp_yanky", priority = 80},
            {name = "dictionary", keyword_length = 2, priority = 10}
        })
    })
    cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            {name = "lsp_signature_help"}, {name = "lsp_document_symbol"},
            {name = "cmdline"}, {name = "cmdline_history"}, {name = "buffer"}
        }, {})
    })
    cmp.setup.cmdline({"/", "?"}, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            {name = "lsp_signature_help"}, {name = "lsp_document_symbol"},
            {name = "cmdline"}, {name = "cmdline_history"}, {name = "buffer"}
        }, {})
    })
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end

return M
