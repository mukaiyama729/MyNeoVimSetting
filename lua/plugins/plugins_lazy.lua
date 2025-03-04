return {
  { "folke/todo-comments.nvim",    opts = {} },
  -- colorscheme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
  },

  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },
  -- file browser
  { "nvim-tree/nvim-web-devicons", opts = {} },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
      "mrbjarksen/neo-tree-diagnostics.nvim",
    },
    opts = function(_, opts)
      opts.window = {
        position = "left",
        width = 25,
        mapping = {
          ["i"] = "open_split",
          ["s"] = "open_vsplit",
          [">"] = "next_source",
          ["<"] = "prev_source",
        },
        fuzzy_finder_mappings = {
          ["<down>"] = "move_cursor_down",
          ["<C-n>"] = "move_cursor_down",
          ["<up>"] = "move_cursor_up",
          ["<C-p>"] = "move_cursor_up",
          ["<esc>"] = "close",
        },
      }
      opts.event_handlers = {
        {
          event = "file_open_requested",
          handler = function() end,
        },
        {
          event = "directory_opened",
          handler = function() end,
        },
      }
      opts.sources = {
        "filesystem",
        "buffers",
        "git_status",
        "diagnostics",
      }
      opts.filesystem = {
        follow_current_file = true,
        hijack_netrw_behavior = "open_default",
        use_libuv_file_watcher = true,
      }
      opts.diagnostics = {
        auto_preview = {              -- May also be set to `true` or `false`
          enabled = true,             -- Whether to automatically enable preview mode
          preview_config = {},        -- Config table to pass to auto preview (for example `{ use_float = true }`)
          event = "neo_tree_buffer_enter", -- The event to enable auto preview upon (for example `"neo_tree_window_after_open"`)
        },
        bind_to_cwd = true,
        diag_sort_function = "severity", -- "severity" means diagnostic items are sorted by severity in addition to their positions.
        -- "position" means diagnostic items are sorted strictly by their positions.
        -- May also be a function.
        follow_current_file = {        -- May also be set to `true` or `false`
          enabled = true,              -- This will find and focus the file in the active buffer every time
          always_focus_file = false,   -- Focus the followed file, even when focus is currently on a diagnostic item belonging to that file
          expand_followed = true,      -- Ensure the node of the followed file is expanded
          leave_dirs_open = false,     -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
          leave_files_open = false,    -- `false` closes auto expanded files, such as with `:Neotree reveal`
        },
        group_dirs_and_files = true,   -- when true, empty folders and files will be grouped together
        group_empty_dirs = true,       -- when true, empty directories will be grouped together
        show_unloaded = true,          -- show diagnostics from unloaded buffers
        refresh = {
          delay = 100,                 -- Time (in ms) to wait before updating diagnostics. Might resolve some issues with Neovim hanging.
          event = "vim_diagnostic_changed", -- Event to use for updating diagnostics (for example `"neo_tree_buffer_enter"`)
          -- Set to `false` or `"none"` to disable automatic refreshing
          max_items = 10000,           -- The maximum number of diagnostic items to attempt processing
          -- Set to `false` for no maximum
        },
      }
      return opts
    end,
    cmd = "Neotree",
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {},
    event = "VeryLazy",
  },
  -- tabline
  {
    "kdheepak/tabline.nvim",
    opts = {},
    event = "BufWinEnter",
  },
  -- indent
  {
    "echasnovski/mini.indentscope",
    opts = {
      symbol = "▏",
    },
    event = "BufRead",
  },
  -- nvim-treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufRead", "BufNewFile", "InsertEnter" },
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")
      configs.setup({
        ensure_installed = {
          "awk",
          "bash",
          "comment",
          "c",
          "css",
          "csv",
          "diff",
          "gpg",
          "html",
          "htmldjango",
          "javascript",
          "typescript",
          "json",
          "lua",
          "markdown",
          "python",
          "rust",
          "sql",
          "ssh_config",
          "tmux",
          "toml",
          "vim",
          "xml",
          "yaml",
          "regex",
          "vimdoc",
        },
        sync_install = false,
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
  -- noice
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      routes = {
        {
          filter = { event = "msg_show", find = "E486: Pattern not found: .*" },
          opts = { skip = true },
        },
      },
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        },
      },
    },
  },
}
