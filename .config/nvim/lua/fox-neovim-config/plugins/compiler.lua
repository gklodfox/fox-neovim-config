local M = { "Zeioth/compiler.nvim" }

M.dependencies = {
  "stevearc/overseer.nvim",
}
M.cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" }

function M.init()
  vim.api.nvim_set_keymap("n", "<F6>", "<cmd>CompilerOpen<cr>", { noremap = true, silent = true })
  -- Redo last selected option
  vim.api.nvim_set_keymap(
    "n",
    "<S-F6>",
    "<cmd>CompilerStop<cr>" -- (Optional, to dispose all tasks before redo)
      .. "<cmd>CompilerRedo<cr>",
    { noremap = true, silent = true }
  )
  -- Toggle compiler results
  vim.api.nvim_set_keymap("n", "<S-F7>", "<cmd>CompilerToggleResults<cr>", { noremap = true, silent = true })
end

function M.config(_, opts)
  require("compiler").setup(opts)
end

return M
