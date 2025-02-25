local M = { "hrsh7th/nvim-cmp" }

M.dependencies = {
  "hrsh7th/cmp-buffer",
  "FelipeLema/cmp-async-path",
  "hrsh7th/cmp-nvim-lua",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-calc",
  "micangl/cmp-vimtex",
  "mtoohey31/cmp-fish",
  "petertriho/cmp-git",
  "hrsh7th/cmp-cmdline",
  "lukas-reineke/cmp-rg",
  "hrsh7th/cmp-nvim-lsp-document-symbol",
  "hrsh7th/cmp-nvim-lsp-signature-help",
  "L3MON4D3/LuaSnip",
  "rafamadriz/friendly-snippets",
  "onsails/lspkind.nvim",
  "doxnit/cmp-luasnip-choice",
  "saadparwaiz1/cmp_luasnip",
  "ray-x/cmp-treesitter",
  -- "tzachar/cmp-ai",
  "windwp/nvim-autopairs",
  "williamboman/mason-lspconfig.nvim",
  {
    "garymjr/nvim-snippets",
    opts = { friendly_snippets = true },
    dependencies = { "rafamadriz/friendly-snippets" },
  },
  {
    "KadoBOT/cmp-plugins",
    config = function()
      require("cmp-plugins").setup({
        files = {
          ".*\\.lua",
          "$HOME/.config/nvim/lua/fox-neovim-config/plugins/.*\\.lua",
        },
      })
    end,
  },
}
M.event = "InsertEnter"
function M.opts()
  local cmp = require("cmp")
  local luasnip = require("luasnip")
  local lspkind = require("lspkind")
  local insert_opts = { behavior = cmp.SelectBehavior.Insert, select = true }

  return {
    auto_brackets = {
      "python",
      "lua",
      "rust",
      "fish",
      "sh",
      "bash",
      "json",
      "markdown",
      "yaml",
      "toml",
      "html",
      "css",
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    completion = {
      completeopt = "menu,menuone,noinsert",
    },
    preselect = { select = true } and cmp.PreselectMode.Item or cmp.PreselectMode.None,
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<Down>"] = cmp.mapping.select_next_item(insert_opts),
      ["<Up>"] = cmp.mapping.select_prev_item(insert_opts),
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
      ["<C-Space>"] = cmp.mapping.complete({}),
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
      format = lspkind.cmp_format({
        mode = "symbol", -- show only symbol annotations
        maxwidth = {
          -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
          -- can also be a function to dynamically calculate max width such as
          -- menu = function() return math.floor(0.45 * vim.o.columns) end,
          menu = 50, -- leading text (labelDetails)
          abbr = 50, -- actual suggestion item
        },
        ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
        show_labelDetails = true, -- show labelDetails in menu. Disabled by default

        -- The function below will be called before any actual modifications from lspkind
        -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
        before = function(entry, vim_item)
          -- ...
          return vim_item
        end,
      }),
      -- fields = { "menu", "abbr", "kind" },
      -- format = function(entry, item)
      --   item.kind = require("mini.icons").get("lsp", item.kind) .. " " .. item.kind
      --
      --   item.menu = ({
      --     buffer = "[Buffer]",
      --     render_markdown = "[MD]",
      --     luasnip = "[Luasnip]",
      --     nvim_lua = "[Lua]",
      --     -- cmp_ai = "[Ai]",
      --     -- codeium = "[Codeium]",
      --     async_path = "[Async Path]",
      --     path = "[Path]",
      --     nvim_lsp_signature_help = "[Signature]",
      --     nvim_lsp_document_symbol = "[Symbol]",
      --     calc = "[Calc]",
      --     plugins = "[Plugins]",
      --     rg = "[Ripgrep]",
      --     treesitter = "[Treesitter]",
      --   })[entry.source.name]
      --
      --   return item
      -- end,
    },
    sources = require("cmp").config.sources({
      { name = "lazydev", group_index = 0 },
      { name = "nvim_lsp" },
      { name = "render-markdown" },
      { name = "luasnip" },
      { name = "async_path" },
      { name = "path" },
      { name = "nvim_lua" },
      -- { name = "codeium" },
      -- { name = "cmp_ai" },
      { name = "luasnip_choice" },
      { name = "nvim_lsp_signature_help" },
      { name = "snippets" },
      { name = "nvim_lsp_document_symbol" },
      { name = "plugins" },
      -- { name = "vimtex" },
      { name = "cmp_ai" },
      { name = "calc" },
      { name = "rg" },
      { name = "treesitter" },
      { name = "plugins" },
      { name = "buffer" },
    }, {}),
    experimental = {
      ghost_text = vim.g.ai_cmp and { hl_group = "CmpGhostText" } or false,
    },
    sorting = {
      comparators = {
        cmp.config.compare.offset,
        cmp.config.compare.exact,
        cmp.config.compare.recently_used,
        require("clangd_extensions.cmp_scores"),
        cmp.config.compare.kind,
        cmp.config.compare.sort_text,
        cmp.config.compare.length,
        cmp.config.compare.order,
      },
    },
  }
end

function M.config(_, opts)
  local cmp = require("cmp")
  cmp.setup(opts)
  cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = "buffer" },
    },
  })
  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = "path", option = { trailing_slash = true } },
    }, {
      { name = "cmdline", option = { treat_trailing_slash = false } },
    }),
    matching = { disallow_symbol_nonprefix_matching = false },
  })
  cmp.setup.filetype("tex", {
    sources = {
      { name = "vimtex" },
      { name = "luasnip" },
      { name = "buffer" },
    },
  })

  -- cmp.setup.cmdline("/", {
  --   mapping = cmp.mapping.preset.cmdline(),
  --   sources = {
  --     { name = "buffer" },
  --   },
  -- })
  -- --
  -- -- -- `:` cmdline setup.
  -- cmp.setup.cmdline(":", {
  --   mapping = cmp.mapping.preset.cmdline(),
  --   sources = cmp.config.sources({
  --     { name = "path" },
  --   }, {
  --     { name = "cmdline" },
  --   }),
  --   matching = { disallow_symbol_nonprefix_matching = false },
  -- })
end

return M
