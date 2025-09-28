local M = {"hrsh7th/nvim-cmp"}

local has_words_before = function()
    local line, col = table.unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and
               vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col,
                                                                          col)
                   :match("%s") == nil
end

M.dependencies = {
    "hrsh7th/cmp-buffer", "FelipeLema/cmp-async-path", "hrsh7th/cmp-nvim-lua",
    "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-calc", "micangl/cmp-vimtex",
    "mtoohey31/cmp-fish", "petertriho/cmp-git", "hrsh7th/cmp-cmdline",
    "lukas-reineke/cmp-rg", "hrsh7th/cmp-nvim-lsp-document-symbol",
    "hrsh7th/cmp-nvim-lsp-signature-help", "L3MON4D3/LuaSnip",
    "rafamadriz/friendly-snippets", "onsails/lspkind.nvim",
    -- "doxnit/cmp-luasnip-choice",
    "saadparwaiz1/cmp_luasnip", "ray-x/cmp-treesitter", -- "tzachar/cmp-ai",
    "windwp/nvim-autopairs", "williamboman/mason-lspconfig.nvim", {
        "KadoBOT/cmp-plugins",
        config = function()
            require("cmp-plugins").setup({
                files = {
                    ".*\\.lua",
                    vim.fn.expand("~") ..
                        "/.config/nvim/lua/fox-neovim-config/plugins/.*\\.lua"
                }
            })
        end
    }
}
M.event = "InsertEnter"
M.enabled = false
function M.opts()
    local cmp = require("cmp")
    local insert_opts = {behavior = cmp.SelectBehavior.Insert, select = true}

    return {
        auto_brackets = {
            "python", "lua", "rust", "fish", "sh", "bash", "json", "markdown",
            "yaml", "toml", "html", "css"
        },
        window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered()
        },
        completion = {completeopt = "menu,menuone,noinsert"},
        preselect = cmp.PreselectMode.Item,
        snippet = {
            expand = function(args)
                require("luasnip").lsp_expand(args.body)
            end
        },
        mapping = cmp.mapping.preset.insert({
            ["<CR>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true
                    })
                else
                    fallback() -- Default behavior (new line)
                end
            end, {"i", "s"}),
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<Down>"] = cmp.mapping.select_next_item(insert_opts),
            ["<Up>"] = cmp.mapping.select_prev_item(insert_opts),
            ["<Tab>"] = cmp.mapping(function(fallback)
                local ls = require("luasnip")
                if cmp.visible() then
                    cmp.select_next_item()
                elseif ls.expand_or_jumpable() then
                    ls.expand_or_jump()
                elseif has_words_before() then
                    cmp.complete()
                else
                    fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
                end
            end, {"i", "s"}),
            ["<S-Tab>"] = cmp.mapping(function()
                local ls = require("luasnip")
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif ls.jumpable(-1) then
                    ls.jump(-1)
                end
            end, {"i", "s"})
        }),
        --   ["<C-x>"] = cmp.mapping(
        --     cmp.mapping.complete({
        --       config = {
        --         sources = cmp.config.sources({
        --           { name = "cmp_ai" },
        --         }),
        --       },
        --     }),
        --     { "i" }
        --   ),
        -- }),
        formatting = {
            fields = {"menu", "abbr", "kind"},
            format = function(entry, item)
                item.kind =
                    require("mini.icons").get("lsp", item.kind) .. " " ..
                        item.kind

                item.menu = ({
                    buffer = "[Buffer]",
                    lazydev = "[LazyDev]",
                    render_markdown = "[MD]",
                    luasnip = "[Luasnip]",
                    nvim_lua = "[Lua]",
                    nvim_lsp = "[Lsp]",
                    -- cmp_ai = "[Ai]",
                    -- codeium = "[Codeium]",
                    async_path = "[Async Path]",
                    path = "[Path]",
                    nvim_lsp_signature_help = "[Signature]",
                    nvim_lsp_document_symbol = "[Symbol]",
                    calc = "[Calc]",
                    snippets = "[Snppets]",
                    plugins = "[Plugins]",
                    rg = "[Ripgrep]",
                    treesitter = "[Treesitter]"
                })[entry.source.name]

                return item
            end
        },
        sources = cmp.config.sources({
            {name = "lazydev", group_index = 0}, {name = "nvim_lsp"},
            {name = "render-markdown"}, {name = "luasnip"},
            {name = "async_path"}, {name = "path"}, {name = "nvim_lua"},
            -- { name = "codeium" },
            -- { name = "cmp_ai" },
            -- { name = "luasnip_choice" },
            {name = "nvim_lsp_signature_help"}, {name = "snippets"},
            {name = "nvim_lsp_document_symbol"}, {name = "plugins"},
            -- { name = "vimtex" },
            -- { name = "cmp_ai" },
            {name = "calc"}, {name = "rg", keyword_length = 6},
            {name = "treesitter"}, {name = "plugins"}, {name = "fish"},
            {name = "buffer"}
        }, {}),
        experimental = {ghost_text = true},
        sorting = {
            comparators = {
                cmp.config.compare.offset, cmp.config.compare.exact,
                cmp.config.compare.recently_used,
                require("clangd_extensions.cmp_scores"),
                cmp.config.compare.kind, cmp.config.compare.sort_text,
                cmp.config.compare.length, cmp.config.compare.order
            }
        }
    }
end

function M.config(_, opts)
    local cmp = require("cmp")
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    local handlers = require("nvim-autopairs.completion.handlers")

    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({
        filetypes = {
            -- "*" is a alias to all filetypes
            ["*"] = {
                ["("] = {
                    kind = {
                        cmp.lsp.CompletionItemKind.Function,
                        cmp.lsp.CompletionItemKind.Method
                    },
                    handler = handlers["*"]
                }
            },
            lua = {
                ["("] = {
                    kind = {
                        cmp.lsp.CompletionItemKind.Function,
                        cmp.lsp.CompletionItemKind.Method
                    },
                    ---@param char string
                    ---@param item table item completion
                    ---@param bufnr number buffer number
                    ---@param rules table
                    ---@param commit_character table<string>
                    handler = function(char, item, bufnr, rules,
                                       commit_character)
                        print(vim.inspect({
                            char, item, bufnr, rules, commit_character
                        }))
                    end
                }
            },
            -- Disable for tex
            tex = false
        }
    }))
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    cmp.setup.cmdline({"/", "?"}, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {{name = "buffer"}}
    })
    cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources({{name = "git"}}, {{name = "buffer"}})
    })
    require("cmp_git").setup()
    cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({{name = "path"}}, {{name = "cmdline"}}),
        matching = {disallow_symbol_nonprefix_matching = false}
    })
    cmp.setup.filetype("tex", {
        sources = {{name = "vimtex"}, {name = "luasnip"}, {name = "buffer"}}
    })
    cmp.setup(opts)
end

return M
