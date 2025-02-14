local M = { "nvimdev/dashboard-nvim" }

M.event = "VimEnter"

function M.opts()
  local ascii_art = {
    "╔════════════════════════════════════╗",
    "║             ／＞-- フ              ║",
    "║            | 　_　_|  miau.        ║",
    "║          ／` ミ＿xノ               ║",
    "║        /　 　　 |                  ║",
    "║       /　  ヽ　|                   ║",
    "║       │　　 | ||   MIAU   ╱|、     ║",
    "║   ／￣|　　 | ||        (˚ˎ 。7    ║",
    "║  ( ￣ ヽ＿_ヽ_)__)       |、˜ |    ║",
    "║   ＼二)                  じしˍ,)ノ ║",
    "╚════════════════════════════════════╝",
  }
  return {
    theme = "hyper",
    config = {
      header = ascii_art,
      shortcut = {
        { desc = "Plugins", group = "@property", action = "Lazy", key = "p" },
        { desc = " Files", group = "Label", action = "Telescope find_files hidden=true", key = "f" },
        { desc = " Grep", group = "Label", action = "Telescope live_grep", key = "g" },
        { desc = " Git files", group = "Label", action = "Telescope git_files", key = "G" },
        { desc = " Projects", group = "Label", action = "Telescope project", key = "P" }
      }
    }
  }
end

return M
