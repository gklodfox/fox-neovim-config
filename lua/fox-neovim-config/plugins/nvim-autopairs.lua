local M = { "windwp/nvim-autopairs" }

M.event = "InsertEnter"

function M.opts()
  return {
    disable_filetype = { "TelescopePrompt", "vim" },
    -- disable_in_macro = true, -- disable when recording or executing a macro
    -- disable_in_visualblock = false, -- disable when insert after visual block mode
    -- disable_in_replace_mode = true,
    -- ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
    -- enable_moveright = true,
    -- enable_afterquote = true, -- add bracket pairs after quote
    -- enable_check_bracket_line = true, --- check bracket in same line
    -- enable_bracket_in_quote = true, --
    -- enable_abbr = false, -- trigger abbreviation
    -- break_undo = true, -- switch for basic rule break undo sequence
    -- check_ts = true,
    -- ts_config = {
    --   lua = {'string'},-- it will not add a pair on that treesitter node
    -- },
    -- map_cr = true,
    -- map_bs = true, -- map the <BS> key
    -- map_c_h = false, -- Map the <C-h> key to delete a pair
    -- map_c_w = false, -- map <c-w> to delete a pair if possible
  }
end

function M.config(_, opts)
  local npairs = require("nvim-autopairs")
  -- local Rule = require('nvim-autopairs.rule')
  -- local ts_conds = require('nvim-autopairs.ts-conds')


  -- press % => %% only while inside a comment or string
  npairs.setup(opts)
end
--   npairs.add_rules({
--     Rule("%", "%", "lua")
--       :with_pair(ts_conds.is_ts_node({'string','comment'})),
--     Rule("$", "$", "lua")
--       :with_pair(ts_conds.is_not_ts_node({'function'}))
--   })
-- end

return M
