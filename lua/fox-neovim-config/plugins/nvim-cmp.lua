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
  "rafamadriz/friendly-snippets",
  "onsails/lspkind.nvim",
  "doxnit/cmp-luasnip-choice",
  "saadparwaiz1/cmp_luasnip",
  "ray-x/cmp-treesitter",
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
  vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
  local cmp = require("cmp")
  local luasnip = require("luasnip")
  local insert_opts = { behavior = cmp.SelectBehavior.Insert }
  local select_opts = { behavior = cmp.SelectBehavior.Replace, select = true }

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
      completeopt = "menu,menuone,noinsert"
    },
    -- preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
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
      ["<C-Right>"] = cmp.mapping.complete(),
      ["<C-Left>"] = cmp.mapping.abort(),
      ["<CR>"] = cmp.mapping.confirm(select_opts),
      ["<S-CR>"] = cmp.mapping.confirm(select_opts), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    formatting = {
      fields = { "menu", "abbr", "kind" },
      format = function(entry, item)
        item.kind = require("mini.icons").get("lsp", item.kind) .. " " .. item.kind

        item.menu = ({
          buffer = "[Buffer]",
          render_markdown = "[MD]",
          luasnip = "[Luasnip]",
          nvim_lua = "[Lua]",
          codeium = "[Codeium]",
          async_path = "[Async Path]",
          path = "[Path]",
          nvim_lsp_signature_help = "[Signature]",
          nvim_lsp_document_symbol = "[Symbol]",
          calc = "[Calc]",
          plugins = "[Plugins]",
          rg = "[Ripgrep]",
          treesitter = "[Treesitter]",
        })[entry.source.name]

        return item
      end,
    },
    sources = require("cmp").config.sources({
      { name = "lazydev", group_index = 0 },
      { name = "nvim_lsp" },
      { name = "render-markdown" },
      { name = "luasnip" },
      { name = "async_path" },
      { name = "path" },
      { name = "nvim_lua" },
      { name = "codeium" },
      { name = "cmp_ai" },
      { name = "luasnip_choice" },
      { name = "nvim_lsp_signature_help" },
      { name = "snippets" },
      { name = "nvim_lsp_document_symbol" },
      { name = "plugins" },
      { name = "calc" },
      { name = "rg", keyword_length = 6 },
      { name = "treesitter" },
      { name = "plugins" },
    }, { { name = "buffer" } }),
    experimental = {
      ghost_text = vim.g.ai_cmp and { hl_group = "CmpGhostText" } or false,
    },
  }
end

function M.config(_, opts)
  local cmp = require("cmp")

  cmp.setup(opts)
  cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })
  --
  -- -- `:` cmdline setup.
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
  })
end

return M
