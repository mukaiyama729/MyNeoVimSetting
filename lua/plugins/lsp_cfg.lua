local lsp_servers = {
  "pyright",
  "ruff",
  "jdtls",
  "bashls",
  "lua_ls",
  "yamlls",
  "jsonls",
  "taplo",
  "rust_analyzer",
  "ts_ls",
  "html",
  "cssls",
}

local formatters = {
  "djlint",
  "black",
  "isort",
  "stylua",
  "shfmt",
  "prettier",
  "google_java_format",
}

local diagnostics = {
  "yamllint",
  "selene",
}

local function get_python_path(workspace)
  -- 1. `venv` ディレクトリがあれば、その `python` を使う
  if vim.fn.glob(workspace .. "/venv/bin/python") ~= "" then
    return workspace .. "/venv/bin/python"
  end
  -- 2. `.venv` ディレクトリがあれば、その `python` を使う
  if vim.fn.glob(workspace .. "/.venv/bin/python") ~= "" then
    return workspace .. "/.venv/bin/python"
  end
  -- 3. Conda の場合
  if vim.fn.getenv("CONDA_PREFIX") ~= vim.NIL then
    return vim.fn.getenv("CONDA_PREFIX") .. "/bin/python"
  end
  -- 4. システムの Python をデフォルトにする
  return "python"
end

return {
  -- LSP のアイコン表示 (VSCode風)
  {
    "onsails/lspkind.nvim",
    event = "InsertEnter",
  },

  -- Mason + LSP
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
      "jay-babu/mason-null-ls.nvim",
      "nvimtools/none-ls.nvim",
    },
    event = { "VeryLazy" },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = lsp_servers,
      })

      local lspconfig = require("lspconfig")
      for _, lsp_server in ipairs(lsp_servers) do
        if lsp_server == "pyright" then
          lspconfig[lsp_server].setup({
            root_dir = function(fname)
              return lspconfig.util.find_git_ancestor(fname) or vim.fn.getcwd()
            end,
            settings = {
              python = {
                pythonPath = get_python_path(vim.fn.getcwd()),
                analysis = {
                  typeCheckingMode = "off",
                  autoSearchPaths = true,
                  useLibraryCodeForTypes = true,
                  diagnosticMode = "workspace",
                },
              },
            },
          })
          goto continue
        end

        if lsp_server == "ts_ls" then
          lspconfig[lsp_server].setup({
            root_dir = function(fname)
              return lspconfig.util.find_git_ancestor(fname) or vim.fn.getcwd()
            end,
          })
          goto continue
        end

        lspconfig[lsp_server].setup({
          root_dir = function(fname)
            return lspconfig.util.find_git_ancestor(fname) or vim.fn.getcwd()
          end,
        })
        ::continue::
      end
    end,
    cmd = "Mason",
  },

  -- Mason + None-LS（Linter & Formatter の設定）
  {
    "jay-babu/mason-null-ls.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "nvimtools/none-ls.nvim",
    },
    config = function()
      require("mason-null-ls").setup({
        automatic_setup = true,
        ensure_installed = vim.tbl_flatten({ formatters, diagnostics }),
        handlers = {},
      })
    end,
    cmd = "Mason",
  },

  -- None-LS の設定（Linter & Formatter）

  {
    "nvimtools/none-ls.nvim",
    requires = "nvim-lua/plenary.nvim",
    dependencies = { "nvimtools/none-ls-extras.nvim" },
    config = function()
      local null_ls = require("null-ls")

      -- Python 用フォーマッタを、Conda アクティベート済みの python から呼び出す例
      --"black" と "isort" を例示していますが、不要なら省略してOKです。
      local python_formatting_sources = {
        null_ls.builtins.formatting.black.with({
          command = function()
            return vim.fn.exepath("python") or "python"
          end,
          args = { "-m", "black", "--quiet", "-" },
        }),
        null_ls.builtins.formatting.isort.with({
          command = function()
            return vim.fn.exepath("python") or "python"
          end,
          args = { "-m", "isort", "-" },
        }),
      }

      local python_diagnostics_sources = {
        null_ls.builtins.diagnostics.pylint.with({
          command = function()
            return vim.fn.exepath("python") or "python"
          end,
          args = { "-m", "pylint", "-f", "json" },
        }),
      }

      local eslint_diagnostics_sources = {
        null_ls.builtins.diagnostics.eslint_d,
      }

      -- Python以外のフォーマッタ
      local other_formatting_sources = {
        null_ls.builtins.formatting.stylua,         -- Lua
        null_ls.builtins.formatting.prettier,       -- JS/TS/HTML/CSS など
        null_ls.builtins.formatting.shfmt,          -- Shell Script
        null_ls.builtins.formatting.djlint,         -- Django Templates
        null_ls.builtins.formatting.google_java_format, -- Java
      }

      -- Python以外の診断（linter）
      local other_diagnostics_sources = {
        null_ls.builtins.diagnostics.yamllint, -- YAML
        null_ls.builtins.diagnostics.selene, -- Lua
        null_ls.builtins.diagnostics.semgrep, -- typescript
        null_ls.builtins.diagnostics.eslint_d, -- JS/TS/HTML/CSS など
        -- 必要に応じて他の診断ツールを追加
      }

      -- すべてをまとめて sources に渡す
      null_ls.setup({
        sources = {
          null_ls.builtins.diagnostics.yamllint, -- YAML
          null_ls.builtins.diagnostics.selene, -- Lua
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.completion.spell,
          null_ls.builtins.formatting.stylua, -- Lua
          null_ls.builtins.formatting.prettier, -- JS/TS/HTML/CSS など
          null_ls.builtins.formatting.shfmt, -- Shell Script
          null_ls.builtins.formatting.djlint, -- Django Templates
          null_ls.builtins.formatting.google_java_format,
          require("none-ls.diagnostics.eslint"),
          null_ls.builtins.diagnostics.pylint,
          null_ls.builtins.formatting.black,
          null_ls.builtins.formatting.isort,
        },
      })
      -- 保存時に自動フォーマット

      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = {
          "*.py",
          "*.lua",
          "*.js",
          "*.ts",
          "*.html",
          "*.css",
          "*.yaml",
          "*.sh",
          "*.jinja",
          "*.java",
        },
        callback = function()
          vim.lsp.buf.format({ async = false })
        end,
      })
    end,
    event = { "BufReadPre", "BufNewFile" },
  },

  -- LSP UI 強化 (lspsaga)
  {
    "nvimdev/lspsaga.nvim",
    config = function()
      require("lspsaga").setup({
        symbol_in_winbar = {
          separator = "  ",
        },
      })
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    event = { "BufRead", "BufNewFile" },
  },

  -- デバッグアダプター (DAP)
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = {
      ensure_installed = {
        "python",
      },
      handlers = {},
    },
  },
}
