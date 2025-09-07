local M = {'2kabhishek/nerdy.nvim'}
M.dependencies = { 'folke/snacks.nvim' }
M.cmd = 'Nerdy'

function M.opts()
    return {
        max_recents = 30,
        add_default_keybindngs = true,
        copy_to_clipboard = false,
    }
end

return M
