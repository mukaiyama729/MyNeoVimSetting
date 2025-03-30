-- lazy.nvim boot strap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- plugins ディレクトリ内でのmoduleのimport
local plugins = {
  { import = "plugins" },
}

--Lazyでパッケージを管理するための設定
local opts = {
  root = vim.fn.stdpath("data") .. "/lazy",                -- directory where plugins will be installed, default: ~/.local/share/nvim/lazy
  lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json", -- lockfile generated by Lazy.nvim, default: ~/.local/share/nvim/lazy/lazy-lock.json
  concurrency = 10,
  checker = { enabled = true },
  log = { level = "info" },
}

-- init.lua の冒頭または LSP 設定ファイルの先頭に追加
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  update_in_insert = false, -- 挿入モード中は更新しない
})

-- leader キーの設定 自分 はspaceにしてる
vim.g.mapleader = " "

-- lazyを setupするため
require("lazy").setup(plugins, opts)

-- coreディレクトリのファイルを読み込み
require("core.options")
require("core.autocmds")
require("core.keymaps")

--require("user.ui")
--require("original.my-toggle.toggle-comment").setup()
