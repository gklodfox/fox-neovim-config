local set_global = vim.g
local set_option = vim.o
local set_options = vim.opt

set_global.mapleader = ' '
set_global.maplocalleader = ' '
set_global.have_nerd_font = false

set_option.number = true
set_option.relativenumber = true
set_option.mouse = 'a'
set_option.showmode = false

vim.schedule(function()
    set_option.clipboard = 'unnamedplus'
end)

set_option.breakindent = true
set_option.undofile = true
set_option.ignorecase = true
set_option.smartcase = true
set_option.signcolumn = 'yes'
set_option.updatetime = 250
set_option.timeoutlen = 300

set_option.splitright = true
set_option.splitbelow = true

set_option.list = true
set_options.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

set_option.inccomand = 'split'
set_option.cursorline = true
set_option.scrolloff = 10
set_option.confirm = true
