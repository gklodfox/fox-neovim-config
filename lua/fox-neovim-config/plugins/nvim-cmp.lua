local M = { "hrsh7th/nvim-cmp" }

M.dependencies = {
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-nvim-lua",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-calc",
    {"mtoohey31/cmp-fish", ft = "fish"},
    "petertriho/cmp-git",
    "hrsh7th/cmp-cmdline",
    "lukas-reineke/cmp-rg",
    "hrsh7th/cmp-nvim-lsp-document-symbol",
    "hrsh7th/cmp-nvim-lsp-signature-help",
    { "L3MON4D3/LuaSnip", version = "v2.*",  build = "make install_jsregexp" },
    { "windwp/nvim-autopairs", opts = { fast_wrap = {} } },
    "rafamadriz/friendly-snippets",
    "onsails/lspkind.nvim",
    { "doxnit/cmp-luasnip-choice", config = function() require('cmp_luasnip_choice').setup({ auto_open = true }) end },
    "saadparwaiz1/cmp_luasnip",
    "ray-x/cmp-treesitter",
    "williamboman/mason-lspconfig.nvim",
}

function M.opts()
  local cmp_status_ok, cmp = pcall(require, "cmp")
  if not cmp_status_ok then
    return
  end
  -- local cmp = require("cmp")
  -- local luasnip = require("luasnip")
  -- local cmp_select = { behavior = cmp.SelectBehavior.Select }

  return {
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end
    },
    formatting = {
      fields = { "kind", "abbr", "menu" },
      format = require('lspkind').cmp_format({
        with_text = 'true', -- show only symbol annotations
        maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
        ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
        show_labelDetails = true, -- show labelDetails in menu. Disabled by default
        menu = ({
            nvim_lsp = "[LSP]",
            luasnip = "[LuaSnip]",
            luasnip_choice = "[LuaSnip]",
            path = "[Path]",
            calc = "[Calc]",
            git = "[Git]",
            treesitter = "[TS]",
            nvim_lsp_signature_help = "[LspSig]",
            rg = "[Rg]",
            buffer = "[Buffer]",

        })
      })
    },
    sources = cmp.config.sources({
      {name = 'nvim_lsp', keyword_length = 1},
      {name = 'luasnip', keyword_length = 2},
      {name = 'luasnip_choice', keyword_length = 2},
      {name = 'path'},
      {name = 'calc'},
      {name = 'git'},
      {name = 'treesitter'},
      {name = 'nvim_lsp_signature_help'},
      {name = 'rg', keyword_length = 3},
      {name = 'buffer', keyword_length = 3},
    }),
    mapping = cmp.mapping.preset.insert({
      ['<Up>'] = cmp.mapping.select_prev_item(),
      ['<Down>'] = cmp.mapping.select_next_item(),

      ['<C-Up>'] = cmp.mapping.scroll_docs(-4),
      ['<C-Down>'] = cmp.mapping.scroll_docs(4),

      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({select = true}),
      ['<Tab>'] = cmp.mapping(function(fallback)
        local luasnip = require("luasnip")
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end, {'i', 's'}),
      ['<S-Tab>'] = cmp.mapping(function(fallback)
        local luasnip = require("luasnip")
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, {'i', 's'})
    }),
    confirm_opts = {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    },
    experimental = {
      ghost_text = true,
    }
  }
end

function M.config(_, opts)
  local cmp = require("cmp")

  local cmp_autopairs = require("nvim-autopairs.completion.cmp")
  local cmp_autopairs_handlers = require("nvim-autopairs.completion.handlers")
  cmp.event:on(
    "confirm_done",
    cmp_autopairs.on_confirm_done({
      filetypes = {
        -- "*" is a alias to all filetypes
        ["*"] = {
          ["("] = {
            kind = {
              cmp.lsp.CompletionItemKind.Function,
              cmp.lsp.CompletionItemKind.Method,
            },
            handler = cmp_autopairs_handlers["*"]
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
            handler = function(char, item, bufnr, rules, commit_character)
              -- Your handler function. Inspect with print(vim.inspect{char, item, bufnr, rules, commit_character})
            end
          }
        },
        -- Disable for tex
        tex = false
      }
    })
  )

  require('luasnip.loaders.from_vscode').lazy_load()

  cmp.setup(opts)

  require("cmp_git").setup()

  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = "git" },
    }, {
      { name = "buffer" },
    })
  })
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = "buffer" }
    }
  })
  cmp.setup.cmdline({ '/' }, {
    sources = cmp.config.sources({
      { name = "nvim_lsp_document_symbol" }
    }, {
      { name = "buffer" }
    }),
  })
  cmp.setup.cmdline({ ':' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = "path" }
    }, {
      { name = "cmdline" }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
  })
end

return M
