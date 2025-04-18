return {
  {
    "olimorris/onedarkpro.nvim",
    priority = 1000, -- Ensure it loads first
    opts = {
      styles = {
        types = "NONE",
        methods = "NONE",
        numbers = "NONE",
        strings = "NONE",
        comments = "italic",
        keywords = "bold,italic",
        constants = "NONE",
        functions = "italic",
        operators = "NONE",
        variables = "NONE",
        parameters = "NONE",
        conditionals = "italic",
        virtual_text = "NONE",
      },
    },
  },
  { "folke/neodev.nvim",        opts = {} },
  { "folke/todo-comments.nvim", opts = {} },
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
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },
  --  -- file browser
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
          ["S"] = "open_split",
          ["s"] = "open_vsplit",
          [">"] = "next_source",
          ["<"] = "prev_source",
          ["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
          ["<space>"] = {
            "toggle_node",
            nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
          },
        },
        fuzzy_finder_mappings = {
          ["<down>"] = "move_cursor_down",
          ["<C-n>"] = "move_cursor_down",
          ["<up>"] = "move_cursor_up",
          ["<C-p>"] = "move_cursor_up",
          ["<esc>"] = "close",
        },
      }
      opts.sources = {
        "filesystem",
        "buffers",
        "git_status",
        "diagnostics",
      }
      opts.filesystem = {
        follow_current_file = {
          enabled = true,
        },
        hijack_netrw_behavior = "open_default",
        use_libuv_file_watcher = true,
        commands = {
          avante_add_files = function(state)
            local node = state.tree:get_node()
            local filepath = node:get_id()
            local relative_path = require("avante.utils").relative_path(filepath)

            local sidebar = require("avante").get()

            local open = sidebar:is_open()
            -- ensure avante sidebar is open
            if not open then
              require("avante.api").ask()
              sidebar = require("avante").get()
            end

            sidebar.file_selector:add_selected_file(relative_path)

            -- remove neo tree buffer
            if not open then
              sidebar.file_selector:remove_selected_file("neo-tree filesystem [1]")
            end
          end,
        },
        window = {
          mappings = {
            ["oa"] = "avante_add_files",
          },
        },
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
  -- treesitterは高度な構文ハイライトを行うためのプラグイン
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "windwp/nvim-ts-autotag",
    },
    event = { "BufRead", "BufNewFile", "InsertEnter" },
    build = ":TSUpdate",
    config = function()
      require("nvim-ts-autotag").setup()
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
          "java",
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
        ignore_install = { "javascript" },
      })
    end,
  },
  --   {
  --     "nvim-ts-autotag",
  --     event = "BufReadPre",
  --     opts = {
  --       opts = {
  --         -- Defaults
  --         enable_close = true,       -- Auto close tags
  --         enable_rename = true,      -- Auto rename pairs of tags
  --         enable_close_on_slash = false, -- Auto close on trailing </
  --       },
  --       -- Also override individual filetype configs, these take priority.
  --       -- Empty by default, useful if one of the "opts" global settings
  --       -- doesn't work well in a specific filetype
  --     },
  --   },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
    opts = {
      fast_wrap = {
        map = "<C-b>",
        chars = { "{", "[", "(", '"', "'" },
        pattern = [=[[%'%"%>%]%)%}%,]]=],
        end_key = "$",
        before_key = "h",
        after_key = "l",
        cursor_pos_before = true,
        keys = "qwertyuiopzxcvbnmasdfghjkl",
        manual_position = true,
        highlight = "Search",
        highlight_grey = "Comment",
      },
    },
    -- use opts = {} for passing setup options
    -- this is equivalent to setup({}) function
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
      notify = {
        view = "mini",
      },

      cmdline = {
        enabled = true,     -- enables the Noice cmdline UI
        view = "cmdline_popup", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
        opts = {},          -- global options for the cmdline. See section on views
        ---@type table<string, CmdlineFormat>
        format = {
          -- conceal: (default=true) This will hide the text in the cmdline that matches the pattern.
          -- view: (default is cmdline view)
          -- opts: any options passed to the view
          -- icon_hl_group: optional hl_group for the icon
          -- title: set to anything or empty string to hide
          cmdline = { pattern = "^:", icon = "", lang = "vim" },
          search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
          search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
          filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
          lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
          help = { pattern = "^:%s*he?l?p?%s+", icon = "" },
          input = { view = "cmdline_input", icon = "󰥻 " }, -- Used by input()
          -- lua = false, -- to disable a format, set to `false`
        },
      },
      routes = {
        {
          filter = { event = "msg_show", find = "E486: Pattern not found: .*" },
          opts = { skip = true },
        },
        {
          filter = { event = "msg_show", kind = "", find = "書込み$" },
          opts = { skip = true },
        },

        {
          filter = { event = "msg_show", kind = "", find = "written$" },
          opts = { skip = true },
        },
      },
      lsp = {
        progress = {
          progess = {
            enabled = true,
            format = "lsp_progress",
            format_done = "lsp_progress_done",
            throttle = 1000,
            view = "notify",
          },
        },
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        },
      },
    },
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = true,
    opts = { open_mapping = [[<C-a>]], insert_mapping = true, direction = "float", terminal_mapping = true },
  },
  {
    "kylechui/nvim-surround",
    version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end,
  },
}
