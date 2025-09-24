local M = {'benlubas/molten-nvim'}

M.dependencies = { "3rd/image.nvim" }

M.build = ":UpdateRemotePlugins"
M.version = "^1.0.0"

function M.init()
    vim.g.molten_image_provider = "image.nvim"
    vim.g.molten_output_win_max_height = 20
    vim.g.molten_auto_open_output = false
    vim.g.molten_wrap_output = true
    vim.g.molten_virt_text_output = true
    vim.g.molten_virt_lines_off_by_1 = true
end



return M
