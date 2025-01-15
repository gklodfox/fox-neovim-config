local M = {"Zeioth/compiler.nvim"}

M.dependencies = {
    "stevearc/overseer.nvim",
    commit = "6271cab7ccc4ca840faa93f54440ffae3a3918bd",
    cmd = {"CompilerOpen", "CompilerToggleResults", "CompilerRedo"},
}
M.cmd = {"CompilerOpen", "CompilerToggleResults", "CompilerRedo"}

function M.init()
  vim.api.nvim_set_keymap('n', '<F6>', "<cmd>CompilerOpen<cr>", { noremap = true, silent = true })
  -- Redo last selected option
  vim.api.nvim_set_keymap('n', '<S-F6>',
       "<cmd>CompilerStop<cr>" -- (Optional, to dispose all tasks before redo)
    .. "<cmd>CompilerRedo<cr>",
   { noremap = true, silent = true })
  -- Toggle compiler results
  vim.api.nvim_set_keymap('n', '<S-F7>', "<cmd>CompilerToggleResults<cr>", { noremap = true, silent = true })
end

function M.config(_, opts)
    require("overseer").setup({
        task_list = {
            direction = "bottom",
            min_height = 25,
            max_height = 25,
            default_detail = 2,
        }
    })
    require("compiler").setup(opts)
end

return M
