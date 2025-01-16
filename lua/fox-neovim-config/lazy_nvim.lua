local M = {}

function M.opts()
  return {
    defaults = { lazy = true },
    install = { colorscheme = { "flow" } },
    ui = {
      icons = {
        ft = "",
        lazy = "󰂠 ",
        loaded = "",
        not_loaded = "",
      },
    },
    performance = {
      rtp = {
        disabled_plugins = {
          "tohtml",
          "gzip",
          "netrw",
          "netrwPlugin",
          "matchit",
          "tarPlugin",
          "zipPlugin",
          "tutor",
        },
      },
    },
    checker = { enabled = true }
  }
end

function M.setup(lazypath, lazyrepo, theme="flow")
  if not vim.loop.fs_stat(lazypath) then
    vim.notify("Getting "..lazyrepo.." to "..lazypath)
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      lazyrepo,
      "--branch=stable", -- latest stable release
      lazypath,
    })
  end
  require("lazy").setup({{"0xstepit/flow.nvim", build = "make extras"}, M.opts())
  vim.notify("Setup done!")
end

return M
