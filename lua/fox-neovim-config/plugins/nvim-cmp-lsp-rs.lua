local M = { "zjp-CN/nvim-cmp-lsp-rs" }


function M.opts()
  local compare = require("cmp").config.compare
  local comparators = require("cmp_lsp_rs").comparators
  return {
    -- Filter out import items starting with one of these prefixes.
    -- A prefix can be create name, module name or anything an import
    -- path starts with, no matter it's complete or incomplete.
    -- Only literals are recognized: no regex matching.
    unwanted_prefix = { "color", "ratatouille::style::Styled" },
    -- make these kinds prior to others
    -- e.g. make Module kind first, and then Function second,
    --      the rest ordering is merged from a default kind list
    kind = function(k)
      -- The argument in callback is type-aware with opts annotated,
      -- so you can type the CompletionKind easily.
      return { k.Module, k.Function }
    end,
    -- Override the default comparator list provided by this plugin.
    -- Mainly used with key binding to switch between these Comparators.
    combo = {
      -- The key is the name for combination of comparators and used
      -- in notification in swiching.
      -- The value is a list of comparators functions or a function
      -- to generate the list.
      alphabetic_label_but_underscore_last = function()
        return { comparators.sort_by_label_but_underscore_last }
      end,
      recentlyUsed_sortText = function()
        -- Mix cmp sorting function with cmp_lsp_rs.
        return {
          compare.recently_used,
          compare.sort_text,
          comparators.sort_by_label_but_underscore_last,
        }
      end,
    },
  }
end

return M
