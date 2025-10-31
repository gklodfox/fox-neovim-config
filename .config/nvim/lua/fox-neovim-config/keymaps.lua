_ = require('snacks')
local function _if_available(modname)
    if pcall(require, modname) then return true end
    return false
end

local function set_keybind(mode, key, command, opts)
    local desc = opts.desc or ""
    local modname = opts.modname or ""
    require("which-key").add({
        mode = mode,
        cond = function()
            if modname == "" then return true end
            return _if_available(modname)
        end,
        { key, command, desc = desc },
    })
end

assert(_if_available("which-key"))
set_keybind({ "n" }, "\\", vim.cmd.NvimTreeToggle, { modname = "nvim-tree", desc = "Toggle file explorer" })
set_keybind({ "n" }, "<C-S-Down>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
set_keybind({ "n" }, "<C-S-Up>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
set_keybind({ "n" }, "<C-S-Right>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
set_keybind({ "n" }, "<C-S-Left>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })
-- Easy terminal escape
set_keybind({ "t" }, "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal" })
set_keybind({ "n" }, "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clean hl" })
-- Move lines
set_keybind({ "v" }, "<S-Down>", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
set_keybind({ "v" }, "<S-Up>", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

set_keybind({ "n" }, "<leader>zR", require("ufo").openAllFolds, { desc = "Open all folds under the cursor position" })
set_keybind({ "n" }, "<leader>zM", require("ufo").closeAllFolds, { desc = "Close all folds under the cursor position" })
set_keybind({ "n" }, "<leader>zr", require("ufo").openFoldsExceptKinds,
    { desc = "Open folds under the cursor, except for kinds" })
set_keybind({ "n" }, "<leader>zm", require("ufo").closeFoldsWith, { desc = "Close folds under the cursor with..." })

set_keybind({ "n" }, "|", function() Snacks.dashboard() end, { desc = "Toggle dashboard" })
set_keybind({ "n" }, "<leader>ff", function() Snacks.picker.files() end, { desc = "Find files in CWD" })
set_keybind({ "n" }, "<leader>fF", function() Snacks.picker.git_files() end, { desc = "Find files in git CWD" })
set_keybind({ "n" }, "<leader>fG", function() Snacks.picker.git_grep() end, { desc = "Grep files in git CWD" })
set_keybind({ "n" }, "<leader>fb", function() Snacks.picker.buffers() end, { desc = "Find buffer" })
set_keybind({ "n" }, "<leader>fk", function() Snacks.picker.keymaps() end, { desc = "Find keymaps" })
set_keybind({ "n" }, "<leader>fh", function() Snacks.picker.help() end, { desc = "Find help tags" })
set_keybind({ "n" }, "<leader>fH", function() Snacks.picker.cliphist() end, { desc = "Find clipboard history" })
set_keybind({ "n" }, "<leader>fo", function() vim.cmd([[Telescope vim_options]]) end,
    { desc = "Lookup values of neovim settings" })
set_keybind({ "n" }, "<leader>fD", function() Snacks.picker.diagnostics() end,
    { desc = "Search through workspace diagnostics" })
set_keybind({ "n" }, "<leader>fd", function() Snacks.picker.diagnostics_buffer() end,
    { desc = "Search through buffer diagnostics" })
set_keybind({ "n" }, "<leader>fp", function() Snacks.picker.projects() end, { desc = "Find project" })

set_keybind({ "n" }, "<leader>rc", function() require("quarto.runner").run_cell() end, { desc = "run cell" })
set_keybind({ "n" }, "<leader>ra", function() require("quarto.runner").run_above() end, { desc = "run cell and above" })
set_keybind({ "n" }, "<leader>rA", function() require("quarto.runner").run_all() end, { desc = "run all cells" })
set_keybind({ "n" }, "<leader>rl", function() require("quarto.runner").run_line() end, { desc = "run line" })
set_keybind({ "n" }, "<leader>RA", function() require("quarto.runner").run_all(true) end,
    { desc = "run all cells of all languages" })
set_keybind({ "v" }, "<leader>r", function() require("quarto.runner").run_range() end, { desc = "run range" })

set_keybind({ "n" }, "<leader>tt", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
set_keybind({ "n" }, "<leader>tT", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
    { desc = "Buffer Diagnostics (Trouble)" })
set_keybind({ "n" }, "<leader>tl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
    { desc = "LSP Definitions / references / ... (Trouble)" })
set_keybind({ "n" }, "<leader>tL", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List (Trouble)" })
set_keybind({ "n" }, "<leader>tq", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)" })
set_keybind({ "n" }, "<leader>[d", "<cmd>Trouble diagnostics next<cr>", { desc = "Next diagnostic (Trouble)" })
set_keybind({ "n" }, "<leader>]d", "<cmd>Trouble diagnostics previous<cr>", { desc = "Previous diagnostic (Trouble)" })

set_keybind({ "n" }, "<leader>tv", function()
    local new_config = vim.diagnostic.config()
    new_config.virtual_lines = not new_config.virtual_lines
    vim.diagnostic.config(new_config)
end, { desc = "Toggle diagnostic virtual_lines" })
set_keybind({ "n" }, "<leader>tV", function()
    local new_config = vim.diagnostic.config()
    new_config.virtual_text = not new_config.virtual_text
    vim.diagnostic.config(new_config)
end, { desc = "Toggle diagnostic virtual_text" })
set_keybind({ "n" }, "<leader>vj", function()
    require("jenkinsfile_linter").validate()
end, { desc = "Validate Jenkinsfile" })

-- set_keybind({ "n" }, "<leader>rc", require('remote-sshfs.api').connect, { desc = "Connect to remote host" })
-- set_keybind({ "n" }, "<leader>re", require('remote-sshfs.api').edit, { desc = "Edit remote host" })
set_keybind({"n"}, "gb", function() vim.cmd("LualineBuffersJump! " .. vim.v.count) end, {desc = "Go to buffer"})
set_keybind({"n"}, "gB", function() Snacks.bufdelete(vim.v.count) end, {desc = "Close buffer"})
