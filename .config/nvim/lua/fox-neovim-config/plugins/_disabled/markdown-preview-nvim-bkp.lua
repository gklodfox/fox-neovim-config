local M = {'iamcco/markdown-preview.nvim'}

M.cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop'}
M.ft = { 'markdown' }
M.build = 'cd app && npm install'
M.enabled = false

function M.init()
    vim.g.mkdp_filetypes = { 'markdown' }
end

return M
