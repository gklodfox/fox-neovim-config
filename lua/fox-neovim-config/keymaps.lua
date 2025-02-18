local wk = require("which-key")

vim.keymap.set("n", "gb", function()
  vim.cmd("LualineBuffersJump! " .. vim.v.count)
end, { desc = "Jump to buffer" })

vim.keymap.set("n", "gB", "<cmd>LualineBuffersJump $<CR>", { desc = "Jump to the last buffer" })
-- Explorator
vim.keymap.set("n", "\\", vim.cmd.NvimTreeToggle)
vim.keymap.set("n", "<C-S-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
vim.keymap.set("n", "<C-S-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
vim.keymap.set("n", "<C-S-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
vim.keymap.set("n", "<C-S-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- Dashboard
vim.keymap.set("n", "|", ":Dashboard<CR>")

-- Easy terminal escape
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal" })

-- Move lines
vim.keymap.set("v", "<S-Down>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<S-Up>", ":m '<-2<CR>gv=gv")

-- Clear hl on esc
vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>")

vim.keymap.set("n", "<leader>a", function()
  require("harpoon"):list():add()
end)
vim.keymap.set("n", "<C-e>", function()
  require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
end)

vim.keymap.set("n", "<C-h>", function()
  require("harpoon"):list():select(1)
end)
vim.keymap.set("n", "<C-t>", function()
  require("harpoon"):list():select(2)
end)
vim.keymap.set("n", "<C-n>", function()
  require("harpoon"):list():select(3)
end)
vim.keymap.set("n", "<C-s>", function()
  require("harpoon"):list():select(4)
end)

-- Toggle previous & next buffers stored within require('harpoon') list
vim.keymap.set("n", "<C-S-P>", function()
  require("harpoon"):list():prev()
end)
vim.keymap.set("n", "<C-S-N>", function()
  require("harpoon"):list():next()
end)

-- wk.add({
--   mode = { "n", "v" },
--   cond = function()
--     if pcall(require, "chatgpt") then
--       return true
--     end
--     return false
--   end,
--   { "<leader>pc", "<cmd>ChatGPT<CR>", desc = "ChatGPT", icon = "󱙺" },
--   { "<leader>pe", "<cmd>ChatGPTEditWithInstruction<CR>", desc = "Edit with instruction" },
--   { "<leader>pg", "<cmd>ChatGPTRun grammar_correction<CR>", desc = "Grammar Correction" },
--   { "<leader>pt", "<cmd>ChatGPTRun translate<CR>", desc = "Translate" },
--   { "<leader>pk", "<cmd>ChatGPTRun keywords<CR>", desc = "Keywords" },
--   { "<leader>pd", "<cmd>ChatGPTRun docstring<CR>", desc = "Docstring" },
--   { "<leader>pa", "<cmd>ChatGPTRun add_tests<CR>", desc = "Add Tests" },
--   { "<leader>po", "<cmd>ChatGPTRun optimize_code<CR>", desc = "Optimize Code" },
--   { "<leader>ps", "<cmd>ChatGPTRun summarize<CR>", desc = "Summarize" },
--   { "<leader>pf", "<cmd>ChatGPTRun fix_bugs<CR>", desc = "Fix Bugs" },
--   { "<leader>px", "<cmd>ChatGPTRun explain_code<CR>", desc = "Explain Code" },
-- --   { "<leader>pr", "<cmd>ChatGPTRun roxygen_edit<CR>", desc = "Roxygen Edit" },
-- --   { "<leader>pl", "<cmd>ChatGPTRun code_readability_analysis<CR>", desc = "Code Readability Analysis" },
-- -- })
--
wk.add({
  mode = { "n" },
  cond = function()
    if pcall(require, "telescope") then
      return true
    end
    return false
  end,
  { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files in CWD" },
  { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Grep files in CWD" },
  { "<leader>fg", "<cmd>Telescope live_grep_args<CR>", desc = "[args] Grep files in CWD" },
  { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Find buffer" },
  { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Find help tags" },
})
