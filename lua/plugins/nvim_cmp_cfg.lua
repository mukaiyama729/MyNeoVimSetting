local M = {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lua",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "saadparwaiz1/cmp_luasnip",
    "L3MON4D3/LuaSnip",
    "onsails/lspkind.nvim", -- アイコンを追加
  },
  event = { "InsertEnter", "CmdlineEnter" },
}

M.config = function()
  local cmp = require("cmp")
  local lspkind = require("lspkind")
  local luasnip = require("luasnip") -- スニペットを追加

  -- Neovim の補完オプションを設定
  vim.opt.completeopt = { "menu", "menuone", "noselect" }

  cmp.setup({
    -- 補完リストのアイコンを表示
    formatting = {
      format = lspkind.cmp_format({
        mode = "symbol",
        maxwidth = 50,
        ellipsis_char = "...",
        before = function(entry, vim_item)
          return vim_item
        end,
      }),
    },
    -- スニペットの展開方法
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    -- 補完ウィンドウのデザイン
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    -- キーマッピング（Tab での補完選択を追加）
    mapping = cmp.mapping.preset.insert({
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),        -- ドキュメントスクロール（上）
      ["<C-f>"] = cmp.mapping.scroll_docs(4),         -- ドキュメントスクロール（下）
      ["<C-Space>"] = cmp.mapping.complete(),         -- 手動補完
      ["<C-e>"] = cmp.mapping.abort(),                -- 補完をキャンセル
      ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Enter で確定

      -- Tab と Shift-Tab で候補を選択
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end, { "i", "s" }),

      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
    }),
    -- 補完候補のソース
    sources = cmp.config.sources({
      { name = "nvim_lsp" }, -- LSP 補完
      { name = "nvim_lua" }, -- Neovim Lua API 補完
      { name = "luasnip" }, -- スニペット補完
    }, {
      { name = "buffer" }, -- バッファの単語を補完
      { name = "path" },  -- ファイルパス補完
    }),
  })

  -- `:` コマンドラインの補完設定
  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = "path" }, -- パス補完
    }, {
      { name = "cmdline" }, -- コマンド補完
    }),
  })
end

return M
