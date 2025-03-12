local M = { "L3MON4D3/LuaSnip" }

M.build = "make install_jsregexp"
M.lazy = true
M.dependencies = {
  "rafamadriz/friendly-snippets",
  config = function()
    require("luasnip.loaders.from_vscode").lazy_load()
    require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })
  end,
}

function M.opts()
  local types = require("luasnip.util.types")
  return {
    history = true,
    delete_check_events = "TextChanged",
    update_events = { "TextChanged", "TextChangedI" },
    enable_autosnippets = true,
    store_selection_keys = "<Tab>",
    ext_opts = {
      [types.choiceNode] = {
        active = {
          virt_text = { { "●", "GruvboxOrange" } },
        },
      },
      [types.insertNode] = {
        active = {
          virt_text = { { "●", "GruvboxBlue" } },
        },
      },
    },
  }
end

function M.config(_, opts)
  require("luasnip.loaders.from_lua").lazy_load({ paths = "./lua/luasnip/" })
  require("luasnip").setup(opts)
  vim.keymap.set({ "i" }, "<C-k>", function()
    require("luasnip").expand()
  end, { silent = true, desc = "expand autocomplete" })
  vim.keymap.set({ "i", "s" }, "<C-j>", function()
    require("luasnip").jump(1)
  end, { silent = true, desc = "next autocomplete" })
  vim.keymap.set({ "i", "s" }, "<C-L>", function()
    require("luasnip").jump(-1)
  end, { silent = true, desc = "previous autocomplete" })
  vim.keymap.set({ "i", "s" }, "<C-E>", function()
    if require("luasnip").choice_active() then
      require("luasnip").change_choice(1)
    end
  end, { silent = true, desc = "select autocomplete" })
end

return M
