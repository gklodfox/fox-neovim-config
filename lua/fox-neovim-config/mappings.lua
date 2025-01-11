-- Explorator
vim.keymap.set("n", "\\", vim.cmd.NvimTreeToggle)

-- Dashboard
vim.keymap.set("n", "|", ":Dashboard<CR>")

-- Easy terminal escape
vim.keymap.set('t', '<Esc><Esc>', "<C-\\><C-n>", {desc = 'Exit terminal'})

-- Move lines
vim.keymap.set('v', '<S-Down>', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', '<S-Up>', ":m '<-2<CR>gv=gv")

-- Clear hl on esc
vim.keymap.set('n', '<Esc>', ':nohlsearch<CR>')

vim.keymap.set('n', '<Home>', function()
    local col = vim.fn.col('.')
    local first_non_blank = vim.fn.match(vim.fn.getline('.'), '\\S') + 1
    return col == first_non_blank and '0' or '^'
end, { expr = true, silent = true })


