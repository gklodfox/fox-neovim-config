local M = { "nvimdev/dashboard-nvim" }

M.event = "VimEnter"

function M.opts()
  local ascii_art = {
    "╔════════════════════════════════════╗",
    "║                                    ║",
    "║             ／＞-- フ              ║",
    "║            | 　_　_|  miau.        ║",
    "║          ／` ミ＿xノ               ║",
    "║        /　 　　 |                  ║",
    "║       /　  ヽ　|                   ║",
    "║       │　　 | ||   MIAU   ╱|、     ║",
    "║   ／￣|　　 | ||        (˚ˎ 。7    ║",
    "║  ( ￣ ヽ＿_ヽ_)__)       |、˜ |    ║",
    "║   ＼二)                  じしˍ,)ノ ║",
    "║                                    ║",
    "╚════════════════════════════════════╝",
  }

	return {
    theme = "hyper",
    config = {
      header = ascii_art,
      shortcut = {
        { desc = "Plugins", group = "@property", action = "Lazy", key = "p" },
        { desc = " Files", group = "Label", action = "Telescope find_files", key = "f" },
        { desc = " Apps", group = "DiagnosticHint", action = "Telescope app", key = "a" },
        { desc = " dotfiles", group = "Number", action = "Telescope dotfiles", key = "d" }
      }
    }
  }
end

return M
