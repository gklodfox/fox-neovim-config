local M = {"catppuccin/nvim"}

M.name = "catppuccin"
M.priority = 1000
M.enabled = false

function M.opts()
    return {
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        background = { -- :h background
            light = "latte",
            dark = "mocha"
        },
        transparent_background = true, -- disables setting the background color.
        show_end_of_buffer = true, -- shows the '~' characters after the end of buffers
        term_colors = true, -- sets terminal colors (e.g. `g:terminal_color_0`)
        dim_inactive = {
            enabled = true, -- dims the background color of inactive window
            shade = "dark",
            percentage = 0.33 -- percentage of the shade to apply to the inactive window
        },
        no_italic = false, -- Force no italic
        no_bold = false, -- Force no bold
        no_underline = false, -- Force no underline
        styles = {
            comments = {"italic"}, -- Change the style of comments
            conditionals = {"bold"},
            loops = {"bold"},
            functions = {},
            keywords = {"bold", "italic"},
            strings = {"italic"},
            variables = {},
            numbers = {"italic"},
            booleans = {"italic"},
            properties = {"bold"},
            types = {},
            operators = {"bold"},
            miscs = {} -- Uncomment to turn off hard-coded styles
        },
        color_overrides = {},
        custom_highlights = {},
        default_integrations = true,
        integrations = {
            cmp = true,
            nvimtree = true,
            treesitter = true,
            dashboard = true,
            gitsigns = true,
            dropbar = {enabled = true, color_mode = true},
            fidget = true,
            mason = true,
            native_lsp = {
                enabled = true,
                virtual_text = {
                    errors = {"italic"},
                    hints = {"italic"},
                    warnings = {"italic"},
                    information = {"italic"},
                    ok = {"italic"}
                },
                underlines = {
                    errors = {"undercurl"},
                    hints = {"undercurl"},
                    warnings = {"undercurl"},
                    information = {"undercurl"},
                    ok = {"undercurl"}
                },
                inlay_hints = {background = true}
            },
            treesitter_context = true,
            ufo = true,
            rainbow_delimiters = true,
            telescope = {enabled = true},
            lsp_trouble = true,
            which_key = true,
            semantic_tokens = true
        }
    }
end

function M.config(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd.colorscheme("catppuccin")
end

return M
