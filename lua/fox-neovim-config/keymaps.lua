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

require("which-key").add({
  mode = { "n", "v" },
  cond = false, -- function()
  --   if pcall(require, "chatgpt") then
  --     return true
  --   end
  --   return false
  -- end,
  { "<leader>pc", "<cmd>ChatGPT<CR>", desc = "ChatGPT", icon = "󱙺" },
  { "<leader>pe", "<cmd>ChatGPTEditWithInstruction<CR>", desc = "Edit with instruction" },
  { "<leader>pg", "<cmd>ChatGPTRun grammar_correction<CR>", desc = "Grammar Correction" },
  { "<leader>pt", "<cmd>ChatGPTRun translate<CR>", desc = "Translate" },
  { "<leader>pk", "<cmd>ChatGPTRun keywords<CR>", desc = "Keywords" },
  { "<leader>pd", "<cmd>ChatGPTRun docstring<CR>", desc = "Docstring" },
  { "<leader>pa", "<cmd>ChatGPTRun add_tests<CR>", desc = "Add Tests" },
  { "<leader>po", "<cmd>ChatGPTRun optimize_code<CR>", desc = "Optimize Code" },
  { "<leader>ps", "<cmd>ChatGPTRun summarize<CR>", desc = "Summarize" },
  { "<leader>pf", "<cmd>ChatGPTRun fix_bugs<CR>", desc = "Fix Bugs" },
  { "<leader>px", "<cmd>ChatGPTRun explain_code<CR>", desc = "Explain Code" },
  { "<leader>pr", "<cmd>ChatGPTRun roxygen_edit<CR>", desc = "Roxygen Edit" },
  { "<leader>pl", "<cmd>ChatGPTRun code_readability_analysis<CR>", desc = "Code Readability Analysis" },
})

require("which-key").add({
  mode = { 'n' },
  cond = function()
      if pcall(require, "ufo") then
          return true
      end
      return false
  end,
  { "<leader>zR", require("ufo").openAllFolds, desc = "Open all folds under the cursor position" },
  { "<leader>zM", require("ufo").closeAllFolds, desc = "Close all folds under the cursor position" },
  { "<leader>zr", require("ufo").openFoldsExceptKinds, desc = "Open folds under the cursor, except for kinds"},
  { "<leader>zm", require("ufo").closeFoldsWith, desc = "Close folds under the cursor with..."}
})

-- fzf-lua
require("which-key").add({
  mode = { "n" },
  cond = function()
    if pcall(require, "fzf-lua") then
      return true
    end
    return false
  end,
  { "<leader>ff", "<cmd>FzfLua files<CR>", desc = "Find files in CWD" },
  { "<leader>fF", "<cmd>FzfLua git_files<CR>", desc = "Find files in git CWD" },
  { "<leader>fg", "<cmd>FzfLua live_grep<CR>", desc = "Grep files in CWD" },
  { "<leader>fG", "<cmd>FzfLua live_grep cmd = 'git grep --line-number --column --color=always'<CR>", desc = "Grep files in git CWD" },
  { "<leader>fb", "<cmd>FzfLua buffers<CR>", desc = "Find buffer" },
  { "<leader>fk", "<cmd>FzfLua keymaps<CR>", desc = "Find keymaps" },
  { "<leader>fH", "<cmd>FzfLua highlights<CR>", desc = "Find highlights" },
  { "<leader>fh", "<cmd>FzfLua help_tags<CR>", desc = "Find help tags" },
  { "<leader>fc", "<cmd>FzfLua command_history<CR>", desc = "Search command history" },
  { "<leader>fo", "<cmd>FzfLua vim_options<CR>", desc = "Lookup values of neovim settings" },
  { "<leader>fo", "<cmd>FzfLua diagnostics_workspace<CR>", desc = "Search through workspace diagnostics" },
  { "<leader>fp", "<cmd>NeovimProjectDiscover<CR>", desc = "Find project" },
})

-- nvim-lualine/lualine.nvim
require("which-key").add({
  mode = { "n" },
  cond = function()
    if pcall(require, "lualine") then
      return true
    end
    return false
  end,
  { "gb", "<cmd>LualineBuffersJump! " ..tostring(vim.v.count).. "<CR>", desc = "Go to buffer" },
  { "gB", '<cmd>LualineBuffersJump! $<CR>', desc = "Go to last buffer" },
})
