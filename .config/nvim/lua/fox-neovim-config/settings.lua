local set_global = vim.g
local set_opt = vim.opt
-- Recommended settings
set_opt.showcmd = true -- Display incomplete commands
local set_o = vim.o

-- CMDS
vim.cmd('syntax on')
vim.cmd('syntax enable')
vim.cmd('filetype plugin indent on')
vim.cmd('syntax spell notoplevel')

-- GLOBALS
set_global.python3_host_prog = vim.fn.exepath('python')
set_global.have_nerd_font = true

-- WHITESPACE
set_opt.listchars = { space = '_', tab = '>~' }
set_o.cindent = true
set_o.autoindent = true
set_o.smartindent = true
set_o.expandtab = true
set_o.shiftwidth = 4
set_o.tabstop = 8
set_o.softtabstop = 4
set_o.wrap = false
set_o.nrformats = 'alpha'
set_o.backspace = 'indent,eol,start'

-- EDITOR
set_o.number = true
set_o.relativenumber = true
set_o.cursorline = true
set_o.cursorlineopt = "both"
set_o.ruler = false
set_o.ignorecase = true
set_o.smartcase = true
set_o.showmode = false
set_o.mouse = "a"
set_o.smoothscroll = true
set_o.title = true
set_o.inccommand = "split"
set_o.ttimeoutlen = 0
set_opt.timeoutlen = 300
set_o.updatetime = 500
set_o.splitbelow = true
set_o.hidden = true
set_o.splitright = true
set_o.scrolloff = 8
set_o.sidescrolloff = 6
set_o.signcolumn = "yes"
set_o.winborder = 'rounded'

-- MISC
set_opt.autochdir = true
set_opt.cmdheight = 1
set_opt.wildignore:append { '*.o', '*.a', '__pycache__', '*.pyc', 'node_modules', '/venv', '*.txt', '/man', '/log' }
set_o.swapfile = false
set_o.undodir = vim.fn.expand('~') .. "/.nvim/undodir"
set_o.undofile = true
set_o.mmp = 2000
set_o.compatible = false
set_o.completeopt = 'menu,menuone,noselect'
set_o.shortmess = vim.o.shortmess .. 'c'

-- LEADER
set_global.mapleader = " "
set_global.maplocalleader = " "
