local set_global = vim.g
local set_opt = vim.opt
local set_o = vim.o

-- CMDS
vim.cmd('filetype plugin indent on')
-- vim.cmd('syntax spell notoplevel'
set_o.syntax = 'on'

-- GLOBALS
set_global.python3_host_prog = vim.fn.exepath('python')
-- set_global.have_nerd_font = true

-- EDITOR
-- set_opt.listchars:append{space = '_', tab = '>>', trail = '~'}
set_opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
set_opt.laststatus = 3
set_o.smartindent = true
set_o.breakindent = true
-- set_o.tabstop = 4
set_o.wrap = false
-- set_o.nrformats = 'alpha'
set_o.backspace = 'indent,eol,start'
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
set_o.timeoutlen = 300
set_o.updatetime = 250
set_o.splitbelow = true
set_o.splitright = true
set_o.scrolloff = 8
set_o.sidescrolloff = 6
set_o.signcolumn = 'auto'
set_o.winborder = 'rounded'

-- MISC
set_o.autochdir = true
-- set_opt.wildignore:append{
--     '*.o', '*.a', '__pycache__', '*.pyc', 'node_modules', '/venv', '*.txt',
--     '/man', '/log', '/doc'
-- }
set_o.swapfile = false
set_o.undodir = vim.fn.expand('~') .. "/.nvim/undodir"
set_o.undofile = true
set_o.mmp = 2000
set_opt.completeopt:append{'menu', 'menuone', 'noselect'}
