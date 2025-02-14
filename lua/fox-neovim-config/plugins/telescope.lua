local M = {"nvim-telescope/telescope.nvim"}

M.branch = "0.1.x"
M.cmd = "Telescope"

M.dependencies = {
    "nvim-treesitter/nvim-treesitter", 'jonarrien/telescope-cmdline.nvim',
    "nvim-telescope/telescope-file-browser.nvim",
    -- "nvim-telescope/telescope-ui-select.nvim",
    {'nvim-telescope/telescope-fzf-native.nvim', build = 'make'},
    {"HPRIOR/telescope-gpt", dependencies = {"jackMort/ChatGPT.nvim"}},
    "nvim-telescope/telescope-project.nvim",
    "nvim-telescope/telescope-live-grep-args.nvim",
    "smilovanovic/telescope-search-dir-picker.nvim",
    "nvim-telescope/telescope-frecency.nvim",
    "nvim-telescope/telescope-dap.nvim", "debugloop/telescope-undo.nvim"
}

function M.opts()
    local project_actions = require("telescope._extensions.project.actions")
    return {
        extensions = {
            mappings = {
                complete = '<C-Space>',
                -- run_selection = '<C-CR>',
                -- run_input = '<CR>'
            },
            cmdline = {
                -- Adjust telescope picker size and layout
                picker = {layout_config = {width = 120, height = 25}}
            },
            fzf = {
                fuzzy = true,
                override_generic_sorter = true,
                override_file_sorter = true,
                case_mode = "smart_case"
            },
            project = {
                project = {display_type = "full"},
                base_dirs = {{'~/Dotfiles', max_depth = 6}, {'~/Code', max_depth = 5}},
                hidden_files = true, -- default: false
                sync_with_nvim_tree = true, -- default false
                theme = "dropdown",
                on_project_selected = function(prompt_bufnr)
                    local harpoon = require("harpoon")
                    local extensions = require("harpoon.extensions")
                    harpoon.setup({})
                    harpoon:extend(extensions.builtins.command_on_nav("foo bar"));
                    harpoon:extend(extensions.builtins.navigate_with_number());
                    -- Do anything you want in here. For example:
                    project_actions.change_working_directory(prompt_bufnr, false)
                    require("harpoon.extensions").builtins.navigate_with_number(
                        1)
                    vim.cmd(":NvimTreeToggle<CR>")
                end,
                mappings = {
                    n = {
                        ['d'] = project_actions.delete_project,
                        ['r'] = project_actions.rename_project,
                        ['c'] = project_actions.add_project,
                        ['C'] = project_actions.add_project_cwd,
                        ['f'] = project_actions.find_project_files,
                        ['b'] = project_actions.browse_project_files,
                        ['s'] = project_actions.search_in_project_files,
                        ['R'] = project_actions.recent_project_files,
                        ['w'] = project_actions.change_working_directory,
                        ['o'] = project_actions.next_cd_scope
                    },
                    i = {
                        ['<c-d>'] = project_actions.delete_project,
                        ['<c-v>'] = project_actions.rename_project,
                        ['<c-a>'] = project_actions.add_project,
                        ['<c-A>'] = project_actions.add_project_cwd,
                        ['<c-f>'] = project_actions.find_project_files,
                        ['<c-b>'] = project_actions.browse_project_files,
                        ['<c-s>'] = project_actions.search_in_project_files,
                        ['<c-r>'] = project_actions.recent_project_files,
                        ['<c-l>'] = project_actions.change_working_directory,
                        ['<c-o>'] = project_actions.next_cd_scope,
                        ['<c-w>'] = project_actions.change_workspace
                    }
                }
            },
            frecency = {
                db_root = vim.fn.stdpath("state"),
                ignore_patterns = {
                    "*.git/*", "*/tmp/*", "*/node_modules/*", "term://*",
                    "*/doc/*"
                }
            },
            gpt = {
                title = "Gpt Actions",
                commands = {
                    "add_tests", "chat", "docstring", "explain_code",
                    "fix_bugs", "grammar_correction", "interactive",
                    "optimize_code", "summarize", "translate"
                },
                theme = require("telescope.themes").get_dropdown {}
            }
        }
    }
end

function M.config(_, opts)
    local telescope = require("telescope")

    telescope.setup(opts)
    require("telescope").load_extension("frecency")
    require("telescope").load_extension("project")
    require("telescope").load_extension("live_grep_args")
    require("telescope").load_extension("dap")
    require("telescope").load_extension("fzf")
    require("telescope").load_extension("gpt")
    -- require("telescope").load_extension("ui-select")
    require("telescope").load_extension("search_dir_picker")
    require("telescope").load_extension('cmdline')
end

return M
