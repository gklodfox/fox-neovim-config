local cmp = require("cmp")
local function has_words_before()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  if col == 0 then
    return false
  end
  local line_text = vim.api.nvim_get_current_line()
  return line_text:sub(col, col):match("%s") == nil
end

local M = { "hrsh7th/nvim-cmp" }

M.event = "VimEnter"
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
  "lukas-reineke/cmp-under-comparator",
  "hrsh7th/cmp-nvim-lsp-document-symbol",
  "hrsh7th/cmp-nvim-lsp-signature-help",
  "L3MON4D3/LuaSnip",
  "windwp/nvim-autopairs",
  "rafamadriz/friendly-snippets",
  "onsails/lspkind.nvim",
  "doxnit/cmp-luasnip-choice",
  "KadoBOT/cmp-plugins",
  "yutkat/cmp-mocword",
  "saadparwaiz1/cmp_luasnip",
  "ray-x/cmp-treesitter",
  "williamboman/mason-lspconfig.nvim",
  "chrisgrieser/cmp_yanky",
  -- "tzachar/cmp-ai",
  "zjp-CN/nvim-cmp-lsp-rs",
  "quangnguyen30192/cmp-nvim-tags",
  "delphinus/cmp-ctags",
}

M.keys = {
  -- See opts.combo from nvim-cmp-lsp-rs below
  {
    "<leader>bc",
    "<cmd>lua require'cmp_lsp_rs'.combo()<cr>",
    desc = "(nvim-cmp) switch comparators"
  },
}

function M.init()
  vim.opt.completeopt = {"menu", "menuone", "noselect"}
end

function M.opts()
  local types = require("cmp.types")
  local cmp_lsp_rs = require("cmp_lsp_rs")
  local luasnip = require("luasnip")

  return {
    completion = {
      completeopt = {"menu", "menuone", "noselect" }
    },
    performance = {
      debounce = 0,
      throttle = 0,
    },
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    },
    sorting = {
      comparators = {
        cmp.config.compare.offset,
        cmp.config.compare.exact,
        cmp.config.compare.score,
        require("cmp-under-comparator").under,
        function(entry1, entry2)
          local kind1 = entry1:get_kind()
          kind1 = kind1 == types.lsp.CompletionItemKind.Text and 100 or kind1
          local kind2 = entry2:get_kind()
          kind2 = kind2 == types.lsp.CompletionItemKind.Text and 100 or kind2
          if kind1 ~= kind2 then
            if kind1 == types.lsp.CompletionItemKind.Snippet then
              return false
            end
            if kind2 == types.lsp.CompletionItemKind.Snippet then
              return true
            end
            local diff = kind1 - kind2
            if diff < 0 then
              return true
            elseif diff > 0 then
              return false
            end
          end
        end,
        cmp.config.compare.sort_text,
        cmp.config.compare.length,
        cmp.config.compare.order,
        cmp_lsp_rs.comparators.inscope_inherent_import,
        cmp_lsp_rs.comparators.sort_by_label_but_underscore_last,
      },
    },
    formatting = {
      -- fields = { "kind", "abbr", "menu" },
      format = require("lspkind").cmp_format({
        with_text = "true", -- show only symbol annotations
        show_labelDetails = true, -- show labelDetails in menu. Disabled by default
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
          -- diag_codes = "[DiagCode]",
          plugins = "[Plugins]",
          fish = "[Fish]",
          cmp_ai = "[AI]",
          ctags = "[Ctags]",
          tags = "[Tags]",
          codeium = "[Codeium]",
        },
      }),
    },
    mapping = {
      ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
      ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
      ["<Up>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
        else
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Up>", true, true, true), "n", true)
        end
      end, { "i" }),
      ["<Down>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
        else
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Down>", true, true, true), "n", true)
        end
      end, { "i" }),
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<C-Down>"] = cmp.mapping(function(fallback)
        if luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<C-Up>"] = cmp.mapping(function(fallback)
        if luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
      -- ["<C-x>"] = cmp.mapping.complete({config = {sources = cmp.config.sources({
      --   { name = "cmp_ai" },
      -- })}}),
      ["<C-q>"] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
      ["<CR>"] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    },
    sources = cmp.config.sources({
      -- { name = "cmp_ai", priority = 100  },
      { name = "nvim_lsp", priority = 100 },
      -- { name = "nvim-cmp-lsp-rs", priority = 100  },
      { name = "luasnip", priority = 85  },
      -- { name = "luasnip_choice", priority = 90  },
      { name = "async_path", priority = 95  },
      { name = "codeium", priority = 70  },
      { name = "nvim_lua",                priority = 50 },
      { name = "nvim_lsp_signature_help", priority = 80  },
      { name = "nvim_lsp_document_symbol", priority = 80  },
      { name = "plugins", priority = 85  },
      { name = "fish", priority = 40 , option = { fish_path = "/usr/bin/fish" } },
    }, {
      { name = "calc", priority = 50  },
      -- { name = "git", priority = 65  },
      -- { name = "diag-codes", priority = 30, option = { in_comment = true } },
      { name = "rg", priority = 95 },
      { name = "tags", priority = 60 },
      { name = "ctags", priority = 60 },
      { name = "buffer", priority = 75 },
      { name = "cmp_yanky", priority = 80  },
      { name = "treesitter", priority = 30  },
    }),
  }
end

function M.config(_, opts)
  cmp.setup.filetype({ "gitcommit", "markdown" }, {
    sources = cmp.config.sources({
      { name = "codeium",     priority = 70 }, -- For luasnip users.
      { name = "nvim_lsp",    priority = 100 },
      -- { name = "nvim_cmp_lsp_rs",    priority = 100 },
      { name = "luasnip",     priority = 85 }, -- For luasnip users.
      -- { name = "luasnip_choice", priority = 90  },
      { name = "nvim_lsp_signature_help", priority = 80  },
      { name = "rg",          priority = 70 },
      { name = "async_path",        priority = 100 },
    }, {
        { name = "buffer",     priority = 50 },
        { name = "spell",      priority = 40 },
        { name = "calc",       priority = 50 },
        { name = "treesitter", priority = 30 },
        { name = "mocword",    priority = 60 },
        -- { name = "git", priority = 65  },
        { name = "cmp_yanky", priority = 80  },
        { name = "dictionary", keyword_length = 2, priority = 10 },
      }),
  })
  cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = "nvim_lsp_signature_help" },
      { name = "nvim_lsp_document_symbol" },
      { name = "cmdline" },
      { name = "cmdline_history" },
      { name = "buffer" },
    }, {}),
  })
  cmp.setup.cmdline(":", {
    mapping = {
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        else
          fallback()
        end
      end, { "c" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end, { "c" }),
      ["<C-y>"] = {
        c = cmp.mapping.confirm({ select = false }),
      },
      ["<C-q>"] = {
        c = cmp.mapping.abort(),
      },
    },
    sources = cmp.config.sources({ { name = "async_path" } }, { { name = "cmdline" }, { { name = "cmdline_history" } } }),
  })
  for _, source in ipairs(opts.sources) do
    require("cmp_lsp_rs").filter_out.entry_filter(source)
  end
  local cmp_autopairs = require("nvim-autopairs.completion.cmp")
  cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

  cmp.setup(opts)
  require("cmp_lsp_rs").setup(opts)
end

return M
