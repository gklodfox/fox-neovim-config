local function _if_available(modname)
    if pcall(require, modname) then return true end
    return false
end

local function set_keybind(mode, key, command, opts)
    local desc = opts.desc or ""
    local modname = opts.modname or ""
    require("which-key").add({
        mode = mode,
        cond = function ()
            if modname == "" then return true end
            return _if_available(modname)
        end,
        {key, command, desc = desc},
    })
end

assert(_if_available("which-key"))

set_keybind({"n"}, "\\", vim.cmd.NvimTreeToggle, {modname = "nvim-tree", desc = "Toggle file explorer"})
set_keybind({"n"}, "<C-S-Down>", "<cmd>resize +2<cr>", {desc = "Increase Window Height"})
set_keybind({"n"}, "<C-S-Up>", "<cmd>resize -2<cr>", {desc = "Decrease Window Height"})
set_keybind({"n"}, "<C-S-Right>", "<cmd>vertical resize -2<cr>", {desc = "Decrease Window Width"})
set_keybind({"n"}, "<C-S-Left>", "<cmd>vertical resize +2<cr>", {desc = "Increase Window Width"})
set_keybind({"n"}, "|", ":Dashboard<CR>", {desc = "Toggle dashboard"})

-- Easy terminal escape
set_keybind({"t"}, "<Esc>", "<C-\\><C-n>", {desc = "Exit terminal"})
set_keybind({"n"}, "<Esc>", "<cmd>nohlsearch<cr>", {desc = "Clean hl"})

-- Move lines
set_keybind({"v"}, "<S-Down>", ":m '>+1<CR>gv=gv", {desc = "Move line down"})
set_keybind({"v"}, "<S-Up>", ":m '<-2<CR>gv=gv", {desc = "Move line up"})

set_keybind({"n", "v"}, "<leader>cc", "<cmd>ChatGPT<CR>", {desc = "ChatGPT", modname = "chatgpt"})
set_keybind({"n", "v"}, "<leader>cA", "<cmd>ChatGPTActAs", {desc = "Act as...", modname = "chatgpt"})
set_keybind({"n", "v"}, "<leader>ce", "<cmd>ChatGPTEditWithInstruction<CR>", {desc = "Edit with instruction", modname = "chatgpt"})
set_keybind({"n", "v"}, "<leader>cg", "<cmd>ChatGPTRun grammar_correction<CR>", {desc = "Grammar Correction", modname = "chatgpt"})
set_keybind({"n", "v"}, "<leader>ct", "<cmd>ChatGPTRun translate<CR>", {desc = "Translate", modname = "chatgpt"})
set_keybind({"n", "v"}, "<leader>ck", "<cmd>ChatGPTRun keywords<CR>", {desc = "Keywords", modname = "chatgpt"})
set_keybind({"n", "v"}, "<leader>cd", "<cmd>ChatGPTRun docstring<CR>", {desc = "Docstring", modname = "chatgpt"})
set_keybind({"n", "v"}, "<leader>ca", "<cmd>ChatGPTRun add_tests<CR>", {desc = "Add Tests", modname = "chatgpt"})
set_keybind({"n", "v"}, "<leader>co", "<cmd>ChatGPTRun optimize_code<CR>", {desc = "Optimize Code", modname = "chatgpt"})
set_keybind({"n", "v"}, "<leader>cs", "<cmd>ChatGPTRun summarize<CR>", {desc = "Summarize", modname = "chatgpt"})
set_keybind({"n", "v"}, "<leader>cf", "<cmd>ChatGPTRun fix_bugs<CR>", {desc = "Fix Bugs", modname = "chatgpt"})
set_keybind({"n", "v"}, "<leader>cx", "<cmd>ChatGPTRun explain_code<CR>", {desc = "Explain Code", modname = "chatgpt"})
set_keybind({"n", "v"}, "<leader>cr", "<cmd>ChatGPTRun roxygen_edit<CR>", {desc = "Roxygen Edit", modname = "chatgpt"})
set_keybind({"n", "v"}, "<leader>cl", "<cmd>ChatGPTRun code_readability_analysis<CR>", {desc = "Code Readability Analysis", modname = "chatgpt"})

require("which-key").add({
    mode = {"n"},
    cond = _if_available("ufo"),
    {
        "<leader>zR",
        require("ufo").openAllFolds,
        desc = "Open all folds under the cursor position"
    },
    {
        "<leader>zM",
        require("ufo").closeAllFolds,
        desc = "Close all folds under the cursor position"
    },
    {
        "<leader>zr",
        require("ufo").openFoldsExceptKinds,
        desc = "Open folds under the cursor, except for kinds"
    },
    {
        "<leader>zm",
        require("ufo").closeFoldsWith,
        desc = "Close folds under the cursor with..."
    }
})

-- fzf-lua
require("which-key").add({
    mode = {"n"},
    cond = _if_available("fzf-lua"),
    {"<leader>ff", "<cmd>FzfLua files<CR>", desc = "Find files in CWD"},
    {"<leader>fF", "<cmd>FzfLua git_files<CR>", desc = "Find files in git CWD"},
    {"<leader>fg", "<cmd>FzfLua live_grep<CR>", desc = "Grep files in CWD"},
    {
        "<leader>fG",
        "<cmd>FzfLua live_grep cmd = 'git grep --line-number --column --color=always'<CR>",
        desc = "Grep files in git CWD"
    },
    {"<leader>fb", "<cmd>FzfLua buffers<CR>", desc = "Find buffer"},
    {"<leader>fk", "<cmd>FzfLua keymaps<CR>", desc = "Find keymaps"},
    {"<leader>fH", "<cmd>FzfLua highlights<CR>", desc = "Find highlights"},
    {"<leader>fh", "<cmd>FzfLua help_tags<CR>", desc = "Find help tags"},
    {
        "<leader>fc",
        "<cmd>FzfLua command_history<CR>",
        desc = "Search command history"
    },
    {
        "<leader>fo",
        "<cmd>FzfLua vim_options<CR>",
        desc = "Lookup values of neovim settings"
    },
    {
        "<leader>fo",
        "<cmd>FzfLua diagnostics_workspace<CR>",
        desc = "Search through workspace diagnostics"
    },
    {"<leader>fp", "<cmd>NeovimProjectDiscover<CR>", desc = "Find project"}
})

-- nvim-lualine/lualine.nvim
require("which-key").add({
    mode = {"n"},
    cond = _if_available("lualine"),
    {
        "gb",
        function() vim.cmd("LualineBuffersJump! " .. vim.v.count) end,
        desc = "Go to buffer"
    }
})

-- require("which-key").add({
--     mode = {"n"},
--     cond = _if_available("quarto"),
--     {
--         "<leader>rc",
--         require("quarto.runner").run_cell,
--         desc = "run cell",
--         silent = true
--     },
--     {
--         "<leader>ra",
--         require("quarto.runner").run_above,
--         desc = "run cell and above",
--         silent = true
--     },
--     {
--         "<leader>rA",
--         require("quarto.runner").run_all,
--         desc = "run all cells",
--         silent = true
--     },
--     {
--         "<leader>rl",
--         require("quarto.runner").run_line,
--         desc = "run line",
--         silent = true
--     },
--     {
--         "<leader>RA",
--         function() require("quarto.runner").run_all(true) end,
--         desc = "run all cells of all languages",
--         silent = true
--     }
-- }, {
--     mode = {"v"},
--     cond = _if_available("quarto"),
--     {
--         "<leader>r",
--         require("quarto.runner").run_range,
--         desc = "run range",
--         silent = true
--     }
-- })

require("which-key").add({
    mode = {"n"},
    cond = _if_available("trouble"),
    {
        "<leader>tt",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)"
    },
    {
        "<leader>tT",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)"
    },
    {
        "<leader>tl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)"
    },
    {
        "<leader>tL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)"
    },
    {
        "<leader>tq",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)"
    },
    {
        "<leader>[d",
        "<cmd>Trouble diagnostics next<cr>",
        desc = "Next diagnostic (Trouble)"
    },
    {
        "<leader>]d",
        "<cmd>Trouble diagnostics previous<cr>",
        desc = "Previous diagnostic (Trouble)"
    }
})

require("which-key").add({
    mode = {"n"},
    cond = _if_available("mason"),
    {
        "<leader>tv",
        function()
            local new_config = vim.diagnostic.config()
            new_config.virtual_lines = not new_config.virtual_lines
            vim.diagnostic.config(new_config)
        end,
        desc = "Toggle diagnostic virtual_lines"
    },
    {
        "<leader>tV",
        function()
            local new_config = vim.diagnostic.config()
            new_config.virtual_text = not new_config.virtual_text
            vim.diagnostic.config(new_config)
        end,
        desc = "Toggle diagnostic virtual_text"
    }
})
