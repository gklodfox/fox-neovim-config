local M = { "nvim-telescope/telescope.nvim" }

local Layout = require("nui.layout")
local Popup = require("nui.popup")

local TSLayout = require("telescope.pickers.layout")
local telescope = require("telescope")

local function make_popup(options)
  local popup = Popup(options)
  function popup.border:change_title(title)
    popup.border.set_text(popup.border, "top", title)
  end
  return TSLayout.Window(popup)
end

-- M.branch = "0.1.x"
M.cmd = "Telescope"
M.event = "VimEnter"

M.dependencies = {
  "nvim-lua/plenary.nvim",
  "nvim-treesitter/nvim-treesitter",
  "jonarrien/telescope-cmdline.nvim",
  "nvim-telescope/telescope-live-grep-args.nvim",
  "nvim-telescope/telescope-file-browser.nvim",
  "nvim-telescope/telescope-ui-select.nvim",
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  "MunifTanjim/nui.nvim",
  -- {"HPRIOR/telescope-gpt", dependencies = {"jackMort/ChatGPT.nvim"}},
  "nvim-telescope/telescope-project.nvim",
  "nvim-telescope/telescope-frecency.nvim",
  "smilovanovic/telescope-search-dir-picker.nvim",
  "nvim-telescope/telescope-dap.nvim",
  "debugloop/telescope-undo.nvim",
  { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
}

function M.opts()
  local actions = require("telescope.actions")
  local project_actions = require("telescope._extensions.project.actions")
  local lga_actions = require("telescope-live-grep-args.actions")
  return {
    pickers = {
      find_files = {
        find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
        mappings = {
          n = {
            ["cd"] = function(prompt_bufnr)
              local selection = require("telescope.actions.state").get_selected_entry()
              local dir = vim.fn.fnamemodify(selection.path, ":p:h")
              require("telescope.actions").close(prompt_bufnr)
              -- Depending on what you want put `cd`, `lcd`, `tcd`
              vim.cmd(string.format("silent lcd %s", dir))
            end,
          },
        },
      },
      buffers = {
        mappings = {
          i = {
            ["<c-d>"] = actions.delete_buffer + actions.move_to_top,
          },
        },
      },
    },
    defaults = {
      defaults = {
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--trim", -- add this value
        },
        layout_strategy = "flex",
        layout_config = {
          horizontal = {
            size = {
              width = "90%",
              height = "60%",
            },
          },
          vertical = {
            size = {
              width = "90%",
              height = "90%",
            },
          },
        },
        create_layout = function(picker)
          local border = {
            results = {
              top_left = "┌",
              top = "─",
              top_right = "┬",
              right = "│",
              bottom_right = "",
              bottom = "",
              bottom_left = "",
              left = "│",
            },
            results_patch = {
              minimal = {
                top_left = "┌",
                top_right = "┐",
              },
              horizontal = {
                top_left = "┌",
                top_right = "┬",
              },
              vertical = {
                top_left = "├",
                top_right = "┤",
              },
            },
            prompt = {
              top_left = "├",
              top = "─",
              top_right = "┤",
              right = "│",
              bottom_right = "┘",
              bottom = "─",
              bottom_left = "└",
              left = "│",
            },
            prompt_patch = {
              minimal = {
                bottom_right = "┘",
              },
              horizontal = {
                bottom_right = "┴",
              },
              vertical = {
                bottom_right = "┘",
              },
            },
            preview = {
              top_left = "┌",
              top = "─",
              top_right = "┐",
              right = "│",
              bottom_right = "┘",
              bottom = "─",
              bottom_left = "└",
              left = "│",
            },
            preview_patch = {
              minimal = {},
              horizontal = {
                bottom = "─",
                bottom_left = "",
                bottom_right = "┘",
                left = "",
                top_left = "",
              },
              vertical = {
                bottom = "",
                bottom_left = "",
                bottom_right = "",
                left = "│",
                top_left = "┌",
              },
            },
          }

          local results = make_popup({
            focusable = false,
            border = {
              style = border.results,
              text = {
                top = picker.results_title,
                top_align = "center",
              },
            },
            win_options = {
              winhighlight = "Normal:Normal",
            },
          })

          local prompt = make_popup({
            enter = true,
            border = {
              style = border.prompt,
              text = {
                top = picker.prompt_title,
                top_align = "center",
              },
            },
            win_options = {
              winhighlight = "Normal:Normal",
            },
          })

          local preview = make_popup({
            focusable = false,
            border = {
              style = border.preview,
              text = {
                top = picker.preview_title,
                top_align = "center",
              },
            },
          })

          local box_by_kind = {
            vertical = Layout.Box({
              Layout.Box(preview, { grow = 1 }),
              Layout.Box(results, { grow = 1 }),
              Layout.Box(prompt, { size = 3 }),
            }, { dir = "col" }),
            horizontal = Layout.Box({
              Layout.Box({
                Layout.Box(results, { grow = 1 }),
                Layout.Box(prompt, { size = 3 }),
              }, { dir = "col", size = "50%" }),
              Layout.Box(preview, { size = "50%" }),
            }, { dir = "row" }),
            minimal = Layout.Box({
              Layout.Box(results, { grow = 1 }),
              Layout.Box(prompt, { size = 3 }),
            }, { dir = "col" }),
          }

          local function get_box()
            local strategy = picker.layout_strategy
            if strategy == "vertical" or strategy == "horizontal" then
              return box_by_kind[strategy], strategy
            end

            local height, width = vim.o.lines, vim.o.columns
            local box_kind = "horizontal"
            if width < 100 then
              box_kind = "vertical"
              if height < 40 then
                box_kind = "minimal"
              end
            end
            return box_by_kind[box_kind], box_kind
          end

          local function prepare_layout_parts(layout, box_type)
            layout.results = results
            results.border:set_style(border.results_patch[box_type])

            layout.prompt = prompt
            prompt.border:set_style(border.prompt_patch[box_type])

            if box_type == "minimal" then
              layout.preview = nil
            else
              layout.preview = preview
              preview.border:set_style(border.preview_patch[box_type])
            end
          end

          local function get_layout_size(box_kind)
            return picker.layout_config[box_kind == "minimal" and "vertical" or box_kind].size
          end

          local box, box_kind = get_box()
          local layout = Layout({
            relative = "editor",
            position = "50%",
            size = get_layout_size(box_kind),
          }, box)

          layout.picker = picker
          prepare_layout_parts(layout, box_kind)

          local layout_update = layout.update
          function layout:update()
            local box, box_kind = get_box()
            prepare_layout_parts(layout, box_kind)
            layout_update(self, { size = get_layout_size(box_kind) }, box)
          end

          return TSLayout(layout)
        end,
      },
      extensions = {
        live_grep_args = {
          auto_quoting = true,
          mappings = { -- extend mappings
            i = {
              ["<C-k>"] = lga_actions.quote_prompt(),
              ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
              ["<C-space>"] = actions.to_fuzzy_refine,
            },
          },
          theme = "dropdown", -- use dropdown theme
        },
        ["ui-select"] = {
          require("telescope.themes").get_dropdown(),
        },
        cmdline = {
          -- Adjust telescope picker size and layout
          picker = { layout_config = { width = 120, height = 25 } },
          mappings = {
            complete = "<Tab>",
            run_selection = "<C-CR>",
            run_input = "<CR>",
          },
        },
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
        project = {
          base_dirs = {
            "$HOME/.config",
            { path = "$HOME/Code", max_depth = 3 },
          },
          project = { display_type = "full" },
          hidden_files = true, -- default: false
          sync_with_nvim_tree = true, -- default false
          theme = "dropdown",
          on_project_selected = function(prompt_bufnr)
            project_actions.change_working_directory(prompt_bufnr, false)
            require("harpoon.extensions").builtins.navigate_with_number(1)
            vim.cmd(":NvimTreeToggle<CR>")
          end,
        },
        frecency = {
          auto_validate = true,
          matcher = "fuzzy",
          path_display = { "filename_first" },
          ignore_patterns = {
            "*/.git/*",
            "*/.git",
            "*/tmp/*",
            "*/node_modules/*",
            "term://*",
            "*/doc/*",
          },
        },
        -- gpt = {
        --     title = "Gpt Actions",
        --     commands = {
        --         "add_tests", "chat", "docstring", "explain_code",
        --         "fix_bugs", "grammar_correction", "interactive",
        --         "optimize_code", "summarize", "translate"
        --     },
        --     theme = require("telescope.themes").get_dropdown {}
        -- }
      },
    },
  }
end

function M.config(_, opts)
  local enabled_extensions =
    { "fzf", "ui-select", "frecency", "project", "live_grep_args", "search_dir_picker", "cmdline" }
  telescope.setup(opts)

  for _, extension in ipairs(enabled_extensions) do
    pcall(telescope.load_extension, extension)
  end

  -- telescope.load_extension("frecency")
  -- telescope.load_extension("project")
  -- -- telescope.load_extension("live_grep_args")
  -- -- telescope.load_extension("dap")
  -- telescope.load_extension("fzf")
  -- -- telescope.load_extension("gpt")
  -- telescope.load_extension("ui-select")
  -- telescope.load_extension("search_dir_picker")
  -- telescope.load_extension("cmdline")
  --
  -- require("telescope").setup(opts)
end

return M
