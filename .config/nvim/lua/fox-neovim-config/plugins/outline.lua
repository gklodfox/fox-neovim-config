local M = { "hedyhli/outline.nvim" }

M.dependencies = {
    "msr1k/outline-asciidoc-provider.nvim",
    "epheien/outline-treesitter-provider.nvim",
    "epheien/outline-ctags-provider.nvim",
    "bngarren/outline-test-blocks-provider.nvim",
}
M.lazy = true
M.cmd = { "Outline", "OutlineOpen" }
M.keys = {
    { "<leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" }
}

function M.opts()
    return {
        outline_window = {
            position = "left",
            auto_jump = true,
        },
        providers = {
            priority = { 'test_blocks', 'lsp', 'markdown', 'treesitter', 'ctags', 'asciidoc' },
        }
    }
end

function M.config(_, opts)
    require("outline").setup(opts)
end

return M
