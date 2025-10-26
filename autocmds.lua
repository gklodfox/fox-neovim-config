vim.api.nvim_create_autocmd('FileType', {
    pattern = "snacks_dashboard",
    callback = function() vim.cmd("stopinsert") end
})
-- Automatically reload the file if it is changed outside of Nvim, see https://unix.stackexchange.com/a/383044/221410.
-- It seems that `checktime` does not work in command line. We need to check if we are in command
-- line before executing this command, see also https://vi.stackexchange.com/a/20397/15292 .
vim.api.nvim_create_augroup("auto_read", { clear = true })

vim.api.nvim_create_autocmd({ "FileChangedShellPost" }, {
    pattern = "*",
    group = "auto_read",
    callback = function()
        vim.notify("File changed on disk. Buffer reloaded!",
            vim.log.levels.WARN, { title = "nvim-config" })
    end
})

vim.api.nvim_create_autocmd({ "FocusGained", "CursorHold" }, {
    pattern = "*",
    group = "auto_read",
    callback = function()
        if vim.fn.getcmdwintype() == "" then vim.cmd("checktime") end
    end
})

-- Resize all windows when we resize the terminal
vim.api.nvim_create_autocmd("VimResized", {
    group = vim.api.nvim_create_augroup("win_autoresize", { clear = true }),
    desc = "autoresize windows on resizing operation",
    command = "wincmd ="
})
local function open_nvim_tree(data)
    local Snacks = require('snacks')
    -- check if buffer is a directory
    local directory = vim.fn.isdirectory(data.file) == 1
    if not directory then
        return
    end
    vim.cmd.enew()
    vim.cmd.bw(data.buf)
    vim.notify(Snacks.git.get_root(data.file))
    if Snacks.git.get_root(data.file) then
        Snacks.explorer.open()
    end
    Snacks.dashboard()
end
vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
-- Do not use smart case in command line mode, extracted from https://vi.stackexchange.com/a/16511/15292.
vim.api.nvim_create_augroup("dynamic_smartcase", { clear = true })
vim.api.nvim_create_autocmd("CmdLineEnter", {
    group = "dynamic_smartcase",
    pattern = ":",
    callback = function() vim.o.smartcase = false end
})

vim.api.nvim_create_autocmd("CmdLineLeave", {
    group = "dynamic_smartcase",
    pattern = ":",
    callback = function() vim.o.smartcase = true end
})

vim.api.nvim_create_autocmd("TermOpen", {
    group = vim.api.nvim_create_augroup("term_start", { clear = true }),
    pattern = "*",
    callback = function()
        -- Do not use number and relative number for terminal inside nvim
        vim.wo.relativenumber = false
        vim.wo.number = false

        -- Go to insert mode by default to start typing command
        vim.cmd("startinsert")
    end
})

-- Return to last cursor position when opening a file, note that here we cannot use BufReadPost
-- as event. It seems that when BufReadPost is triggered, FileType event is still not run.
-- So the filetype for this buffer is empty string.
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api
        .nvim_create_augroup("resume_cursor_position", { clear = true }),
    pattern = "*",
    callback = function(ev)
        local mark_pos = vim.api.nvim_buf_get_mark(ev.buf, '"')
        local last_cursor_line = mark_pos[1]

        local max_line = vim.fn.line("$")
        local buf_filetype = vim.api.nvim_get_option_value("filetype",
            { buf = ev.buf })
        local buftype = vim.api.nvim_get_option_value("buftype", { buf = ev.buf })

        -- only handle normal files
        if buf_filetype == "" or buftype ~= "" then return end

        -- Only resume last cursor position when there is no go-to-line command (something like '+23').
        if vim.fn.match(vim.v.argv, [[\v^\+(\d){1,}$]]) ~= -1 then return end

        if last_cursor_line > 1 and last_cursor_line <= max_line then
            -- vim.print(string.format("mark_pos: %s", vim.inspect(mark_pos)))
            -- it seems that without vim.schedule, the cursor position can not be set correctly
            vim.schedule(function()
                local _, _ = pcall(vim.api.nvim_win_set_cursor, 0, mark_pos)
            end)
            -- the following two ways also seem to work,
            -- ref: https://www.reddit.com/r/neovim/comments/104lc26/how_can_i_press_escape_key_using_lua/
            -- vim.api.nvim_feedkeys("g`\"", "n", true)
            -- vim.fn.execute("normal! g`\"")
        end
    end
})

local number_toggle_group = vim.api.nvim_create_augroup("numbertoggle",
    { clear = true })
vim.api.nvim_create_autocmd({
    "BufEnter", "FocusGained", "InsertLeave", "WinEnter"
}, {
    pattern = "*",
    group = number_toggle_group,
    desc = "togger line number",
    callback = function()
        if vim.wo.number then vim.wo.relativenumber = true end
    end
})

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    group = vim.api.nvim_create_augroup("auto_close_win", { clear = true }),
    desc = "Quit Nvim if we have only one window, and its filetype match our pattern",
    callback = function(_)
        local quit_filetypes = { "qf", "NvimTree", "trouble", "Outline", "Diagnostics", "help", "noice" }

        local should_quit = true
        local tabwins = vim.api.nvim_tabpage_list_wins(0)

        for _, win in pairs(tabwins) do
            local buf = vim.api.nvim_win_get_buf(win)
            local bf = vim.fn.getbufvar(buf, "&filetype")

            if vim.fn.index(quit_filetypes, bf) == -1 then
                should_quit = false
            end
        end

        if should_quit then vim.cmd("qall") end
    end
})

vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.hl.on_yank()
    end,
})
