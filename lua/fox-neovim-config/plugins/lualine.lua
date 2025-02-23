local venv_path = os.getenv("VIRTUAL_ENV")

local get_current_signature = function(width)
  width = width or 10
  if not pcall(require, "lsp_signature") then
    return
  end
  local sig = require("lsp_signature").status_line(width)
  return sig.label .. "" .. sig.hint
end

local get_venv = function()
  if vim.bo.filetype ~= "python" or venv_path == nil then
    return ""
  end
  return vim.fn.fnamemodify(venv_path, ":t")
end

local diff_source = function()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed,
    }
  end
end

local get_active_lsp = function()
  local msg = "No LSP"
  -- local buf_ft = vim.api.nvim_get_option_value("filetype")
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if next(clients) == nil then
    return msg
  end

  for _, client in ipairs(clients) do
    ---@diagnostic disable-next-line: undefined-field
    local filetypes = client.config.filetypes
    if filetypes and vim.fn.index(filetypes, vim.bo.filetype) ~= -1 then
      return client.name
    end
  end
  return msg
end

local M = { "nvim-lualine/lualine.nvim" }

M.dependencies = {
  "nvim-tree/nvim-web-devicons",
  "Isrothy/lualine-diagnostic-message",
  "arkav/lualine-lsp-progress",
  "echasnovski/mini.icons",
}

function M.opts()
  local flow_theme = require("lualine.themes.flow")
  flow_theme.normal.a = { bg = "#ff007b", fg = "#000000" }
  flow_theme.normal.b = { bg = "#60002e", fg = "#ff007b" }
  flow_theme.normal.c = { bg = nil, fg = "#60002e" }
  flow_theme.normal.x = { bg = nil, fg = "#ff007b" }
  flow_theme.normal.y = { fg = "#ff007b", bg = "#60002e" }
  flow_theme.normal.z = { bg = "#ff007b", fg = "#000000" }
  return {
    options = {
      theme = flow_theme,
      icons_enabled = true,
      always_show_tabline = false,
      globalstatus = true,
      disabled_filetypes = {
        statusline = { "dashboard", "NvimTree", "terminal" },
        winbar = { "dashboard", "NvimTree", "terminal" },
      },
    },
    sections = {
      lualine_a = { { get_active_lsp } },
      lualine_b = {
        {
          "filetype",
          icon_only = false,
          colored = true,
          icon = { align = "right" },
        },
      },
      lualine_c = {
        { "diff", source = diff_source, icons_enabled = true },
        {
          "diagnostics",
          sources = {
            "nvim_lsp",
            "nvim_diagnostic",
            "nvim_workspace_diagnostic",
            "vim_lsp",
          },
          sections = { "error", "warn", "info", "hint" },
          diagnostics_color = {
            error = "DiagnosticError", -- Changes diagnostics' error color.
            warn = "DiagnosticWarn", -- Changes diagnostics' warn color.
            info = "DiagnosticInfo", -- Changes diagnostics' info color.
            hint = "DiagnosticHint", -- Changes diagnostics' hint color.
          },
          -- symbols = {error = 'E', warn = 'W', info = 'I', hint = 'H'},
          colored = true, -- Displays diagnostics status in color if set to true.
          update_in_insert = true, -- Update diagnostics in insert mode.
          always_visible = false, -- Show diagnostics even if there are none.
        },
        { "searchcount", maxcount = 999, timeout = 500 },
        "selectioncount",
      },
      lualine_x = {
        {
          "lsp_progress",
          display_components = { "lsp_client_name", { "title", "message" }, "spinner" },
          max_length = 1,
          spinner_symbols = {
            "⠂",
            "⠃",
            "⠊",
            "⠒",
            "⠢",
            "⢂",
            "⡂",
            "⠆",
            "⠂",
            "⠁",
            "⠉",
            "⠑",
            "⠡",
            "⢁",
            "⡁",
            "⠅",
            "⠃",
            "⠁",
            "⠈",
            "⠘",
            "⠨",
            "⢈",
            "⡈",
            "⠌",
            "⠊",
            "⠉",
            "⠈",
            "⠐",
            "⠰",
            "⢐",
            "⡐",
            "⠔",
            "⠒",
            "⠑",
            "⠘",
            "⠐",
            "⠠",
            "⢠",
            "⡠",
            "⠤",
            "⠢",
            "⠡",
            "⠨",
            "⠰",
            "⠠",
            "⢀",
            "⣀",
            "⢄",
            "⢂",
            "⢁",
            "⢈",
            "⢐",
            "⢠",
            "⢀",
            "⡀",
            "⡄",
            "⡂",
            "⡁",
            "⡈",
            "⡐",
            "⡠",
            "⣀",
            "⡀",
            "⠄",
            "⠆",
            "⠅",
            "⠌",
            "⠔",
            "⠤",
            "⢄",
            "⡄",
            "⠄",
          },
          timer = { progress_enddelay = 500, spinner = 10, lsp_client_name_enddelay = 1000 },
        },
        {
          "overseer",
          label = "", -- Prefix for task counts
          colored = true, -- Color the task icons and counts
          symbols = {
            [require("overseer").STATUS.FAILURE] = "F:",
            [require("overseer").STATUS.CANCELED] = "C:",
            [require("overseer").STATUS.SUCCESS] = "S:",
            [require("overseer").STATUS.RUNNING] = "R:",
          },
          unique = false, -- Unique-ify non-running task count by name
          name = nil, -- List of task names to search for
          name_not = false, -- When true, invert the name search
          status = nil, -- List of task statuses to display
          status_not = false, -- When true, invert the status search
        },
      },
      lualine_y = {
        "fileformat",
        { "encoding", fmt = string.upper },
        "filesize",
      },
      lualine_z = { { get_venv }, "branch" },
    },
    winbar = {
      lualine_a = { {
        function()
          return os.date("%R")
        end,
      } },
      lualine_b = {
        {
          "filename",
          file_status = true,
          newfile_status = false,
          path = 1,
          symbols = {
            readonly = "[R]",
            modified = "[~]",
            unnamed = "[*]",
            newfile = "[+]",
          },
        },
      },
      lualine_c = { { get_current_signature } },
      lualine_x = {
        {
          "diagnostic-message",
          colors = {
            error = "#BF616A",
            warn = "#EBCB8B",
            info = "#A3BE8C",
            hint = "#88C0D0",
          },
        },
      },
      lualine_y = {},
      lualine_z = {
        {
          "buffers",
          show_filename_only = true,
          mode = 2,
          filetype_names = { TelescopePrompt = "Telescope", dashboard = "Dashboard", lazy = "Lazy", fzf = "fzf" },
        },
      },
    },
    tabline = {},
    extensions = {
      "lazy",
      "mason",
      "nvim-tree",
      "trouble",
      "fzf",
      "quickfix",
    },
  }
end

function M.config(_, opts)
  local trouble = require("trouble")
  local symbols = trouble.statusline({
    mode = "symbols",
    groups = {},
    title = false,
    filter = { range = true },
    format = "{kind_icon}{symbol.name:Normal}",
    -- The following line is needed to fix the background color
    -- Set it to the lualine section you want to use
    hl_group = "lualine_c_normal",
  })
  table.insert(opts.winbar.lualine_c, { symbols.get, cond = symbols.has })
  -- table.insert(opts.sections.lualine_x, {
  --   get_current_signature(50),
  --   cond = package.loaded["lsp_signature"]
  -- })

  require("lualine").setup(opts)
end

return M
