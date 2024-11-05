vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end

vim.opt.rtp:prepend(lazypath)
local lazy_config = require("fox-neovim-config.lazy_nvim")

require("lazy").setup({
    { import = "fox-neovim-config.plugins" },
}, lazy_config)

require("fox-neovim-config.settings")
require("fox-neovim-config.autocmds")
vim.schedule(function()
    require("fox-neovim-config.mappings")
end)
