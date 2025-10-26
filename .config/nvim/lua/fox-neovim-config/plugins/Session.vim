let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/.kotfiles/fox-neovim-config/.config/nvim/lua/fox-neovim-config/plugins
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +3 ~/.kotfiles/fox-neovim-config/.config/nvim/lua/fox-neovim-config/plugins/snacks.lua
badd +22 ~/.kotfiles/fox-neovim-config/.config/nvim/lua/fox-neovim-config/plugins/nvim-session-manager.lua
badd +0 ~/.kotfiles/fox-neovim-config/.config/nvim/lua/fox-neovim-config/plugins/.config/nvim/lua/fox-neovim-config/plugins/snacks.lua
badd +46 ~/.kotfiles/fox-neovim-config/.config/nvim/lua/fox-neovim-config/plugins/mason.lua
argglobal
%argdel
edit ~/.kotfiles/fox-neovim-config/.config/nvim/lua/fox-neovim-config/plugins/mason.lua
wincmd t
let s:save_winminheight = &winminheight
let s:save_winminwidth = &winminwidth
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
argglobal
balt ~/.kotfiles/fox-neovim-config/.config/nvim/lua/fox-neovim-config/plugins/snacks.lua
setlocal foldmethod=manual
setlocal foldexpr=v:lua.vim.treesitter.foldexpr()
setlocal foldmarker={{{,}}}
setlocal foldignore=#
setlocal foldlevel=99
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldenable
silent! normal! zE
sil! 7,8fold
sil! 5,9fold
sil! 19,20fold
sil! 17,23fold
sil! 16,24fold
sil! 13,26fold
sil! 3,28fold
sil! 34,41fold
sil! 31,45fold
sil! 50,51fold
sil! 54,55fold
sil! 60,61fold
sil! 49,64fold
sil! 47,65fold
sil! 30,66fold
sil! 76,79fold
let &fdl = &fdl
let s:l = 46 - ((8 * winheight(0) + 8) / 17)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 46
normal! 06|
lcd ~/.kotfiles/fox-neovim-config
tabnext 1
if exists('s:wipebuf') && len(win_findbuf(s:wipebuf)) == 0 && getbufvar(s:wipebuf, '&buftype') isnot# 'terminal'
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20
let &shortmess = s:shortmess_save
let &winminheight = s:save_winminheight
let &winminwidth = s:save_winminwidth
let s:sx = expand("<sfile>:p:r")."x.vim"
if filereadable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &g:so = s:so_save | let &g:siso = s:siso_save
set hlsearch
nohlsearch
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
