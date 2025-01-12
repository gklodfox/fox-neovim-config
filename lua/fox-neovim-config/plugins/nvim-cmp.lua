local M = { "hrsh7th/nvim-cmp" }

M.dependencies = {
  "hrsh7th/cmp-buffer",
  "FelipeLema/cmp-async-path",
  "hrsh7th/cmp-nvim-lua",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-calc",
  "mtoohey31/cmp-fish",
  "petertriho/cmp-git",
  "hrsh7th/cmp-cmdline",
  "lukas-reineke/cmp-rg",
  "hrsh7th/cmp-nvim-lsp-document-symbol",
  "hrsh7th/cmp-nvim-lsp-signature-help",
  "L3MON4D3/LuaSnip",
  "windwp/nvim-autopairs",
  "rafamadriz/friendly-snippets",
  "onsails/lspkind.nvim",
  "doxnit/cmp-luasnip-choice",
  "KadoBOT/cmp-plugins",
  "saadparwaiz1/cmp_luasnip",
  "ray-x/cmp-treesitter",
  "williamboman/mason-lspconfig.nvim",
  "chrisgrieser/cmp_yanky",
  "tzachar/cmp-ai",
  "zjp-CN/nvim-cmp-lsp-rs",
  "quangnguyen30192/cmp-nvim-tags",
  "delphinus/cmp-ctags",
}

function M.opts()
  local cmp_status_ok, cmp = pcall(require, "cmp")
  if not cmp_status_ok then
    return
  end

  local cmp_lsp_rs = require("cmp_lsp_rs")
  local comparators = cmp_lsp_rs.comparators
  local compare = require("cmp").config.compare

  return {
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    },
    sorting = {
      comparators = {
        compare.exact,
        compare.score,
        -- comparators.inherent_import_inscope,
        comparators.inscope_inherent_import,
        comparators.sort_by_label_but_underscore_last,
      },
    },
    formatting = {
      fields = { "kind", "abbr", "menu" },
      format = require("lspkind").cmp_format({
        with_text = "true", -- show only symbol annotations
        maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
        ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
        show_labelDetails = true, -- show labelDetails in menu. Disabled by default
        menu = {
          nvim_lsp = "[LSP]",
          luasnip = "[LuaSnip]",
          luasnip_choice = "[SnipChoice]",
          async_path = "[Path]",
          calc = "[Calc]",
          git = "[Git]",
          treesitter = "[TS]",
          cmp_lsp_rs = "[CmpRS]",
          nvim_lsp_signature_help = "[LspSig]",
          nvim_lsp_document_symbol = "[Symbol]",
          rg = "[Rg]",
          buffer = "[Buffer]",
          diag_codes = "[DiagCode]",
          plugins = "[Plugins]",
          fish = "[Fish]",
          cmp_ai = "[AI]",
          ctags = "[Ctags]",
          tags = "[Tags]",
        },
      }),
    },
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "luasnip_choice" },
      { name = "luasnip" },
      { name = "async_path" },
      { name = "calc" },
      { name = "git" },
      { name = "treesitter" },
      { name = "nvim_lsp_signature_help" },
      { name = "nvim_lsp_document_symbol" },
      { name = "diag-codes", option = { in_comment = true } },
      { name = "rg" },
      {
        name = "tags",
        option = {
          -- this is the default options, change them if you want.
          -- Delayed time after user input, in milliseconds.
          complete_defer = 100,
          -- Max items when searching `taglist`.
          max_items = 10,
          -- The number of characters that need to be typed to trigger
          -- auto-completion.
          keyword_length = 3,
          -- Use exact word match when searching `taglist`, for better searching
          -- performance.
          exact_match = false,
          -- Prioritize searching result for current buffer.
          current_buffer_only = false,
        },
      },
      {
        name = "ctags",
        option = {
          executable = "ctags",
          trigger_characters = { "." },
          trigger_characters_ft = {},
        },
      },
      { name = "buffer" },
      { name = "cmp_yanky" },
      { name = "plugins" },
      { name = "cmp_ai" },
      { name = "fish", option = { fish_path = "/usr/bin/fish" } },
      { name = "nvim-cmp-lsp-rs" },
    }),
    mapping = cmp.mapping.preset.insert({
      ["<Up>"] = cmp.mapping.select_prev_item(),
      ["<Down>"] = cmp.mapping.select_next_item(),

      ["<C-Up>"] = cmp.mapping.scroll_docs(-4),
      ["<C-Down>"] = cmp.mapping.scroll_docs(4),

      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-x>"] = cmp.mapping.complete({
        config = {
          sources = cmp.config.sources({
            { name = "cmp_ai" },
          }),
        },
      }),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
      ["<Tab>"] = cmp.mapping(function(fallback)
        local luasnip = require("luasnip")
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        local luasnip = require("luasnip")
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
    }),
    confirm_opts = {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    },
    experimental = {
      ghost_text = true,
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
  }
end

function M.config(_, opts)
  local cmp = require("cmp")

  local cmp_autopairs = require("nvim-autopairs.completion.cmp")
  local cmp_autopairs_handlers = require("nvim-autopairs.completion.handlers")
  local cmp_lsp_rs = require("cmp_lsp_rs")
  local comparators = cmp_lsp_rs.comparators
  local compare = require("cmp").config.compare
  opts.sorting.comparators = {
    compare.exact,
    compare.score,
    -- comparators.inherent_import_inscope,
    comparators.inscope_inherent_import,
    comparators.sort_by_label_but_underscore_last,
  }

  for _, source in ipairs(opts.sources) do
    cmp_lsp_rs.filter_out.entry_filter(source)
  end
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
            handler = cmp_autopairs_handlers["*"],
          },
        },
        lua = {
          ["("] = {
            kind = {
              cmp.lsp.CompletionItemKind.Function,
              cmp.lsp.CompletionItemKind.Method,
            },
            ---@param char string
            ---@param item table item completion
            ---@param bufnr number buffer number
            ---@param rules table
            ---@param commit_character table<string>
            handler = function(char, item, bufnr, rules, commit_character)
              -- Your handler function. Inspect with print(vim.inspect{char, item, bufnr, rules, commit_character})
            end,
          },
        },
        -- Disable for tex
        tex = false,
      },
    })
  )

  require("luasnip.loaders.from_vscode").lazy_load()

  cmp.setup(opts)

  require("cmp_git").setup()

  cmp.setup.filetype("gitcommit", {
    sources = cmp.config.sources({
      { name = "git" },
    }, {
      { name = "buffer" },
    }),
  })
  cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = "buffer" },
    },
  })
  cmp.setup.cmdline({ "/" }, {
    sources = cmp.config.sources({
      { name = "nvim_lsp_document_symbol" },
    }, {
      { name = "buffer" },
    }),
  })
  cmp.setup.cmdline({ ":" }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = "async_path" },
    }, {
      { name = "cmdline" },
    }),
    matching = { disallow_symbol_nonprefix_matching = false },
  })
end

return M
