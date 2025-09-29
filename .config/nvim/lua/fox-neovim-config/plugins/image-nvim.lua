local M = {"3rd/image.nvim"}

function M.opts()
    return {
        -- backend = "ueberzugpp",
        -- processor = "magick_cli", -- or "magick_cli"
        integrations = {
            markdown = {
                enabled = true,
                clear_in_insert_mode = false,
                download_remote_images = true,
                only_render_image_at_cursor = false,
                floating_windows = false, -- if true, images will be rendered in floating markdown windows
                filetypes = {"markdown", "vimwiki"} -- markdown extensions (ie. quarto) can go here
            },
            neorg = {enabled = true, filetypes = {"norg"}},
            typst = {enabled = true, filetypes = {"typst"}},
            html = {enabled = true, filetypes = {"html"}},
            css = {enabled = true, filetypes = {"css"}}
        },
        max_width = 100,
        max_height = 12,
        max_width_window_percentage = math.huge,
        max_height_window_percentage = math.huge,
        window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
        window_overlap_clear_ft_ignore = {
            "cmp_menu", "cmp_docs", "snacks_notif", "scrollview",
            "scrollview_sign"
        }
    }
end

function M.config(_, opts) require("image").setup(opts) end

return M
