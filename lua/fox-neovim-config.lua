local load = function(mod)
  package.loaded[mod] = nil
  require(mod)
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local lazy_config = require("fox-neovim-config.lazy_nvim")

load("fox-neovim-config.settings")
load("fox-neovim-config.autocmds")
vim.schedule(function()
    load("fox-neovim-config.mappings")
end)

require("lazy").setup({
    { import = "fox-neovim-config.plugins" },
}, lazy_config)

vim.cmd [[colorscheme flow]]
