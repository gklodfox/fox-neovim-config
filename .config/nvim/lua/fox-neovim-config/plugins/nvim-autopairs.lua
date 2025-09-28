local M = {"windwp/nvim-autopairs"}

function M.opts()
    return {
        disable_filetype = {"vim"},
        disable_in_macro = true, -- disable when recording or executing a macro
        disable_in_visualblock = false, -- disable when insert after visual block mode
        disable_in_replace_mode = true,
        ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
        enable_moveright = true,
        enable_afterquote = true, -- add bracket pairs after quote
        enable_check_bracket_line = true, --- check bracket in same line
        enable_bracket_in_quote = true, --
        enable_abbr = false, -- trigger abbreviation
        break_undo = true, -- switch for basic rule break undo sequence
        check_ts = true,
        fast_wrap = {
            map = "<M-e>",
            chars = {"{", "[", "(", '"', "'"},
            pattern = [=[[%'%"%>%]%)%}%,]]=],
            end_key = "$",
            before_key = "h",
            after_key = "l",
            cursor_pos_before = true,
            avoid_move_to_end = true, -- stay for direct end_key use
            keys = "qwertyuiopzxcvbnmasdfghjkl",
            manual_position = true,
            highlight = "Search",
            highlight_grey = "Comment"
        },
        map_cr = true
    }
end

function M.config(_, opts)
    local Rule = require("nvim-autopairs.rule")
    local npairs = require("nvim-autopairs")
    local ts_conds = require("nvim-autopairs.ts-conds")
    local cond = require("nvim-autopairs.conds")

    npairs.setup(opts)
    npairs.add_rule(Rule("$$", "$$", "tex"))
    npairs.add_rules({
        Rule("$", "$", {"tex", "latex"}) -- don't add a pair if the next character is %
        :with_pair(cond.not_after_regex("%%")) -- don't add a pair if  the previous character is xxx
        :with_pair(cond.not_before_regex("xxx", 3)) -- don't move right when repeat character
        :with_move(cond.none()) -- don't delete if the next character is xx
        :with_del(cond.not_after_regex("xx")) -- disable adding a newline when you press <cr>
        :with_cr(cond.none())
    }, -- disable for .vim files, but it work for another filetypes
    Rule("a", "a", "-vim"))
    npairs.add_rules({
        Rule("$$", "$$", "tex"):with_pair(function(opt)
            if opt.line == "aa $$" then
                -- don't add pair on that line
                return false
            end
        end)
    })
    -- you can use regex
    -- press u1234 => u1234number
    npairs.add_rules({Rule("u%d%d%d%d$", "number", "lua"):use_regex(true)})
    -- press x1234 => x12341234
    npairs.add_rules({
        Rule("x%d%d%d%d$", "number", "lua"):use_regex(true):replace_endpair(
            function(opt)
                return opt.prev_char:sub(#opt.prev_char - 3, #opt.prev_char)
            end)
    })
    -- you can do anything with regex +special key
    -- example press tab to uppercase text:
    -- press b1234s<tab> => B1234S1234S
    npairs.add_rules({
        Rule("b%d%d%d%d%w$", "", "vim"):use_regex(true, "<tab>")
            :replace_endpair(function(opt)
                return opt.prev_char:sub(#opt.prev_char - 4, #opt.prev_char) ..
                           "<esc>viwU"
            end)
    })
    -- you can exclude filetypes
    npairs.add_rule(Rule("$$", "$$"):with_pair(cond.not_filetypes({"lua"})))
    npairs.setup({
        check_ts = true,
        ts_config = {
            lua = {"string"}, -- it will not add a pair on that treesitter node
            javascript = {"template_string"},
            java = false -- don't check treesitter on java
        }
    })
    -- press % => %% only while inside a comment or string
    npairs.add_rules({
        Rule("%", "%", "lua"):with_pair(ts_conds.is_ts_node({
            "string", "comment"
        })),
        Rule("$", "$", "lua"):with_pair(ts_conds.is_not_ts_node({"function"}))
    })
end

return M
