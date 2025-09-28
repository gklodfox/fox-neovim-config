local M = {'creativenull/diagnosticls-configs-nvim'}

M.dependencies = {'neovim/nvim-lspconfig'}
M.enabled = false

function M.config()
    local dlsconfig = require("diagnosticls-configs")

    dlsconfig.init({default_config = true, format = true})

    dlsconfig.setup()
end
-- function M.opts()
--   local cpplint = require("diagnosticls-configs.linters.cpplint")
--   local cmake = require("diagnosticls-configs.linters.cmakelint")
--   local eslint = require("diagnosticls-configs.linters.eslint")
--   local stylelint = require 'diagnosticls-configs.linters.stylelint'
--   local prettier = require 'diagnosticls-configs.formatters.prettier'
--   local eslint_fmt = require 'diagnosticls-configs.formatters.eslint_fmt'
--   local luacheck = require 'diagnosticls-configs.linters.luacheck'
--   local lua_format = require 'diagnosticls-configs.formatters.lua_format'
--   local flake = require 'diagnosticls-configs.linters.flake'
--   local pylint = require 'diagnosticls-configs.linters.pylint'
--   local mypy = require 'diagnosticls-configs.linters.mypy'
--   local autopep8 = require 'diagnosticls-configs.formatters.autopep8'
--   local black = require 'diagnosticls-configs.formatters.black'
--   local vint = require 'diagnosticls-configs.linters.vint'
--   local yamllint = require 'diagnosticls-configs.linters.yamllint'
--   return {
--     ['cpp'] = {
--       linter = vim.tbl_extend('force', cpplint, {
--         command = "cpplint",
--         args = { vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()) },
--         debounce = 100,
--         isStderr = true,
--         isStdout = false,
--         sourceName = "cpplint",
--         offsetLine = 0,
--         offsetColumn = 0,
--         formatPattern = {
--           ^[^:]+:(\\d+):(\\d+)?\\s+([^:]+?)\\s\\[(\\d)\\]$,
--           {
--             line = 1,
--             column = 2,
--             message = 3,
--             security = 4
--           }
--         },
--         securities = {
--           1 = info,
--           2 = warning,
--           3 = warning,
--           4 = error,
--           5 = error"
--         }
--       })
--     }
--   }  
-- end

return M
