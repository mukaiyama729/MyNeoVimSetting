-- lang
-- vim.cmd('language en_US.UTF-8') -- 表示言語を英語にする
-- local vim = require("vim")
vim.cmd("language ja_JP.UTF-8") -- 表示言語を日本語にする

-- ファイル
vim.opt.fileencoding = "utf-8" -- エンコーディングをUTF-8に設定
vim.opt.swapfile = false       -- スワップファイルを作成しない
-- vim.opt.helplang = "ja" -- ヘルプファイルの言語は日本語
vim.opt.hidden = true          -- バッファを切り替えるときに
--ファイルを保存しなくてもOKに

-- カーソルと表示
-- vim.opt.cursorline = true -- カーソルがある行を強調
-- vim.opt.cursorcolumn = true -- カーソルがある列を強調

-- クリップボード共有
vim.opt.clipboard:append({ "unnamedplus" }) -- レジスタとクリップボードを共有

-- メニューとコマンド
vim.opt.wildmenu = true -- コマンドラインで補完
vim.opt.cmdheight = 1   -- コマンドラインの表示行数
vim.opt.laststatus = 2  -- 下部にステータスラインを表示
vim.opt.showcmd = true  -- コマンドラインに入力されたコマンドを表示

-- 検索・置換え
vim.opt.hlsearch = true  -- ハイライト検索を有効
vim.opt.incsearch = true -- インクリメンタルサーチを有効
vim.opt.matchtime = 1    -- 入力された文字列がマッチするまでにかかる時間

-- カラースキーム
vim.opt.termguicolors = true -- 24 ビットカラーを使用
vim.opt.background = "dark"  -- ダークカラーを使用する

-- インデント
vim.opt.shiftwidth = 2     -- シフト幅を4に設定する
vim.opt.tabstop = 2        -- タブ幅を4に設定する
vim.opt.expandtab = true   -- タブ文字をスペースに置き換える
vim.opt.autoindent = true  -- 自動インデントを有効にする
vim.opt.smartindent = true -- インデントをスマートに調整する

-- 表示
vim.opt.number = true         -- 行番号を表示
vim.opt.relativenumber = true -- 相対行番号を表示
vim.opt.wrap = true           -- テキストの自動折り返しを無効に
vim.opt.showtabline = 2       -- タブラインを表示
-- （1:常に表示、2:タブが開かれたときに表示）
vim.opt.visualbell = true     -- ビープ音を表示する代わりに画面をフラッシュ
vim.opt.showmatch = true      -- 対応する括弧をハイライト表示

-- インタフェース
vim.opt.winblend = 0       -- ウィンドウの不透明度
vim.opt.pumblend = 0       -- ポップアップメニューの不透明度
vim.opt.showtabline = 2    -- タブラインを表示する設定
vim.opt.signcolumn = "yes" -- サインカラムを表示

---- 行番号の色を変更（色は適宜変更してください）
vim.cmd("highlight LineNr guifg=#8a70ac")

-- カーソルの形状
vim.o.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"

-- 行の強調
vim.opt.cursorline = true -- カーソルがある行を強調

-- signcolumnの優先順位（エラー/警告/ヒントの表示順）
vim.diagnostic.config({ severity_sort = true })
-- views can only be fully collapsed with the global statusline
vim.opt.laststatus = 3
-- シンタックスハイライトを有効化
vim.cmd("syntax enable")

-- カラースキームを 'slate' に設定
-- 1vim.cmd("colorscheme tokyonight")
vim.cmd.colorscheme("catppuccin-macchiato")
-- vim.cmd.colorscheme("tokyonight-storm")
-- 折り返しなし
vim.opt.wrap = false
