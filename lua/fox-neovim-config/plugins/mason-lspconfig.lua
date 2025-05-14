local M = { "williamboman/mason-lspconfig.nvim" }

M.dependencies = {
  "stevearc/conform.nvim",
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({
        install_root_dir = vim.fn.stdpath("data") .. "/mason",
        PATH = "prepend",
        ui = {
          border = "rounded",
          icons = {
            package_installed = "✓",
            package_pending = "~",
            package_uninstalled = "✗",
          },
        },
        registries = {
          "github:mason-org/mason-registry",
        },
        providers = {
          "mason.providers.registry-api",
          "mason.providers.client",
        },
        log_level = vim.log.levels.INFO,
        max_concurrent_installers = 8,
      })
    end,
  },
  { "neovim/nvim-lspconfig", lazy = true, dependencies = { "williamboman/mason-lspconfig.nvim" } },
  "saghen/blink.cmp",
  "ray-x/lsp_signature.nvim",
  "simrat39/rust-tools.nvim",
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  "rshkarin/mason-nvim-lint",
  "zapling/mason-conform.nvim",
}

function M.init()
  local sign = function(opts)
    vim.fn.sign_define(opts.name, {
      texthl = opts.name,
      text = opts.text,
      numhl = "",
    })
  end
  vim.opt.rtp:prepend(vim.fn.expand("~") .. "/.local/share/nvim/mason")

  sign({ name = "DiagnosticSignError", text = "✘" })
  sign({ name = "DiagnosticSignWarn", text = "▲" })
  sign({ name = "DiagnosticSignHint", text = "⚑" })
  sign({ name = "DiagnosticSignInfo", text = "" })

  vim.keymap.set("n", "gK", function()
    local new_config = not vim.diagnostic.config().virtual_text
    vim.diagnostic.config({ virtual_lines = new_config })
  end, { desc = "Toggle diagnostic virtual_lines" })

  vim.diagnostic.config({
    virtual_text = true,
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      border = "single",
    },
  })
  vim.filetype.add({ pattern = { [".*/*.asasm"] = "asasm" } })
  vim.api.nvim_create_autocmd("LspAttach", {
    desc = "LSP actions",
    callback = function()
      local bufmap = function(mode, lhs, rhs)
        local opts = { buffer = true }
        vim.keymap.set(mode, lhs, rhs, opts)
      end
      bufmap("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>")
      bufmap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>")
      bufmap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>")
      bufmap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>")
      bufmap("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>")
      bufmap("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>")
      bufmap("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>")
      bufmap("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>")
      bufmap("n", "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>")
      bufmap("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>")
      bufmap("n", "gl", "<cmd>lua vim.diagnostic.open_float()<cr>")
      bufmap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>")
      bufmap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>")
    end,
  })
end
function M.opts()
  return {

    servers = {
      asm_lsp = {},
      diagnosticls = {},
      dockerls = {},
      marksman = {},
      rust_analyzer = {},
      vimls = {},
      yamlls = {},
      html = {},
      jsonls = {},
      taplo = {},
      markdown_oxide = {},
      gradle_ls = {},
      fish_lsp = {
        cmd = { "fish-lsp", "start", "--disable", "signature" },
        cmd_env = {
          fish_lsp_show_client_popups = false,
        },
        filetypes = { "fish" },
      },
      groovyls = {
        cmd = {
          "java",
          "-jar",
          "/home/gklodkox/.local/share/nvim/mason/packages/groovy-language-server/build/libs/groovy-language-server-all.jar",
        },
        filetypes = {
          "groovy",
          "Jenkinsfile",
        },
      },
      lua_ls = {},
      basedpyright = {
        settings = {
          basedpyright = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = "openFilesOnly",
              useLibraryCodeForTypes = true,
            },
          },
        },
      },
      pylsp = {
        settings = {
          pylsp = {
            plugins = {
              -- formatter
              black = { enabled = true },
              pylint = {
                enabled = true,
                -- executable = "pylint",
                args = { "-d C0114,C0115,C0116" },
              },
              pylsp_mypy = {
                enabled = true,
                report_progress = true,
                live_mode = true,
              },
              pycodestyle = {
                ignore = { "W391" },
                maxLineLength = 100,
              },
              isort = { enabled = true },
            },
          },
        },
      },
      bashls = {
        settings = {
          bashIde = { globPattern = "*@(.sh|.inc|.bash|.command)" },
        },
      },
      clangd = {
        filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
        cmd = { "clangd" },
        capabilities = {
          offsetEncoding = { "utf-16" },
          textDocument = {
            completion = {
              editsNearCursor = true,
            },
          },
        },
        init_options = {
          fallbackFlags = { "-std=c++17" },
        },
      },
      neocmake = {
        cmd = { "neocmakelsp", "--stdio" },
        filetypes = { "cmake" },
        root_dir = function(fname)
          return require("lspconfig").util.find_git_ancestor(fname)
        end,
        single_file_support = true, -- suggested
        init_options = {
          format = {
            enable = true,
          },
          lint = {
            enable = true,
          },
          scan_cmake_in_package = true, -- default is true
        },
      },
      texlab = {
        settings = {
          texlab = {
            bibtexFormatter = "texlab",
            build = {
              args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
              executable = "latexmk",
              forwardSearchAfter = false,
              onSave = true,
            },
            chktex = {
              onEdit = true,
              onOpenAndSave = true,
            },
            diagnosticsDelay = 300,
            formatterLineLength = 80,
            forwardSearch = {
              args = {},
            },
            latexFormatter = "tex-fmt",
            latexindent = {
              modifyLineBreaks = false,
            },
          },
        },
      },
    },
  }
end
function M.config(_, opts)
  -- require("neodev").setup({})
  local lspconfig = require("lspconfig")
  for server, config in pairs(opts.servers) do
    -- passing config.capabilities to blink.cmp merges with the capabilities in your
    -- `opts[server].capabilities, if you've defined it
    config.capabilities =
      { textDocument = {
        foldingRange = {
          dynamicRegistration = false,
          lineFoldingOnly = true,
        },
      } }
    config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
    lspconfig[server].setup(config)
  end
  -- local lsp_capabilities = vim.tbl_deep_extend(
  --   "force",
  --   vim.lsp.protocol.make_client_capabilities(),
  --   require("cmp_nvim_lsp").default_capabilities()
  -- )
  require("mason-tool-installer").setup({
    auto_update = true,
    run_on_start = true,
    start_delay = 3000,
    integrations = {
      ["mason-lspconfig"] = true,
      ["mason-null-ls"] = false,
      ["mason-nvim-dap"] = false,
    },
    ensure_installed = {
      "asm_lsp",
      "bashls",
      "neocmake",
      "diagnosticls",
      "dockerls",
      -- "digestif",
      "texlab",
      "gradle_ls",
      "lua_ls",
      "pylsp",
      "marksman",
      "basedpyright",
      "rust_analyzer",
      "vimls",
      "yamlls",
      "clangd",
      "groovyls",
      "html",
      "jsonls",
      "taplo",
      "markdown_oxide",
      "autopep8",
      "black",
      "autoflake",
      "prettierd",
      "luaformatter",
      "stylua",
      "beautysh",
      "fixjson",
      "htmlbeautifier",
      "mdformat",
      "xmlformatter",
      "yamlfix",
      "yamlfmt",
    },
  })

  require("mason-conform").setup({
    ensure_installed = {
      "bibtex-tidy",
      "tex_fmt",
      "autoflake",
      "autopep8",
      "black",
      "ruff_format",
      "isort",
      "cmake_format",
      "clang-format",
      "prettier",
      "shellcheck",
      "shfmt",
      "stylua",
      "yamlfix",
      "fixjson",
      "rustfmt",
      "yamlfmt",
    },
  })
  require("mason-nvim-lint").setup({
    -- ensure_installed = {
    --   "checkmake",
    --   "swiftlint",
    --   "cmakelang",
    --   "codespell",
    --   "cpplint",
    --   "editorconfig-checker",
    --   "eslint_d",
    --   "flake8",
    --   "htmlhint",
    --   "jsonlint",
    --   "luacheck",
    --   "markdownlint",
    --   "commitlint",
    --   "misspell",
    --   "mypy",
    --   "pydocstyle",
    --   "pyflakes",
    --   "pylint",
    --   "revive",
    --   "ruff",
    --   "shellcheck",
    --   "staticcheck",
    --   "systemdlint",
    --   "vint",
    --   "yamllint",
    --   "npm-groovy-lint",
    --   "bacon",
    -- },
  })
end

return M
