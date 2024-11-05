local M = { "hrsh7th/nvim-cmp" }

M.event = "InsertEnter"
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

function M.init()
  vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

  vim.diagnostic.config({
    virtual_text = true,
    severity_sort = true,
    float = {
      border = 'rounded',
      -- source = 'if_many',
    },
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = '✘',
        [vim.diagnostic.severity.WARN] = '▲',
        [vim.diagnostic.severity.INFO] = '⚑',
        [vim.diagnostic.severity.HINT] = '',
      },
    }
  })
  vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
    vim.lsp.handlers.hover,
    {border = 'rounded'}
  )
  vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
    {border = 'rounded'}
  )
end

function M.opts()
  local cmp = require("cmp")
  local luasnip = require("luasnip")
  local cmp_select = { behavior = cmp.SelectBehavior.Select }

  return {
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end
    },
    formatting = {
      fields = {'menu', 'abbr', 'kind'},
      expandable_indicator = true,
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
      ['<Up>'] = cmp.mapping.select_prev_item(cmp_select),
      ['<Down>'] = cmp.mapping.select_next_item(cmp_select),

      ['<C-Up>'] = cmp.mapping.scroll_docs(-4),
      ['<C-Down>'] = cmp.mapping.scroll_docs(4),

      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({select = true, behavior = cmp.ConfirmBehavior.Insert}),
      ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end, {'i', 's'}),
      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, {'i', 's'})
    }),
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },

  }
end

function M.config(_, opts)
  local cmp = require("cmp")

  local cmp_autopairs = require "nvim-autopairs.completion.cmp"
  cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

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

  local lspconfig = require("lspconfig")
  local cmp_nvim_lsp = require("cmp_nvim_lsp")
  local protocol = require("vim.lsp.protocol")

  local completionItem = {
    textDocument = {
      foldingRange = {
          dynamicRegistration = false,
          lineFoldingOnly = true,
        },
      completion = {
        completionItem = {
          documentationFormat = { "markdown", "plaintext" },
          snippetSupport = true,
          preselectSupport = true,
          insertReplaceSupport = true,
          labelDetailsSupport = true,
          deprecatedSupport = true,
          commitCharactersSupport = true,
          tagSupport = { valueSet = { 1 } },
          resolveSupport = {
            properties = {
              "documentation",
              "detail",
              "additionalTextEdits",
            },
          },
        },
      },
    },
  }

  local capabilities = vim.tbl_deep_extend(
    "force",
    protocol.make_client_capabilities(),
    cmp_nvim_lsp.default_capabilities(),
    completionItem
  )
  lspconfig.util.default_config = capabilities
end

return M
