-- local vim = require("vim")
local opts = { noremap = true, silent = true } -- local term_opts = { silent = true }
local keymap = vim.keymap.set
-- オプションテーブルにdescを追加するための簡略化関数
local function ex_opts(desc)
  return vim.tbl_extend("force", opts, { desc = desc })
end
-- Neotree
keymap("n", "<leader>nn", ":Neotree toggle<cr>", ex_opts("Neotree Toggle"))

-- NeoVimのkeymap設定
local map = vim.api.nvim_set_keymap

-- NeoTreeのキーバインド (常に左側で開くように設定)
map("n", "<C-m>", ":Neotree left reveal<CR>", opts)
map("n", "<C-n>", ":Neotree left focus<CR>", opts)
map("n", "<C-t>", ":Neotree left toggle<CR>", opts)

-- カーソル移動のショートカット
map("n", "<C-j>", "5j", opts)
map("n", "<C-k>", "5k", opts)

-- バッファ複製
local function duplicate_vsplit()
  local buf = vim.api.nvim_get_current_buf()
  vim.cmd("vsplit")
  vim.api.nvim_win_set_buf(0, buf)
end

local function duplicate_hsplit()
  local buf = vim.api.nvim_get_current_buf()
  vim.cmd("split")
  vim.api.nvim_win_set_buf(0, buf)
end

-- キーマップを設定
vim.keymap.set("n", "<leader>vs", duplicate_vsplit, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>hs", duplicate_hsplit, { noremap = true, silent = true })

-- 空行を挿入
map("n", "<leader>k", "O<Esc>", opts)
map("n", "<leader>j", "o<Esc>", opts)

-- 定義ジャンプ（新しいウィンドウで開く）
vim.keymap.set("n", "gd", function()
  vim.cmd("split") -- 新しい水平分割ウィンドウを作成
  vim.lsp.buf.definition()
end, { silent = true, desc = "Jump to definition in new split window" })

-- 定義ジャンプ（現在のウィンドウ）
vim.keymap.set("n", "gD", function()
  vim.lsp.buf.definition()
end, { silent = true, desc = "Jump to definition in the same window" })

vim.keymap.set("n", "S-k", vim.lsp.buf.hover, { silent = true, desc = "Show LSP documentation" })

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fc", builtin.git_files, { desc = "Telescope git files" })
vim.keymap.set("n", "<leader>fs", builtin.grep_string, { desc = "Telescope grep string" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })

-- diagnostic
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, ex_opts("Open diagnostic float"))
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, ex_opts("Go to previous diagnostic"))
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, ex_opts("Go to next diagnostic"))
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, ex_opts("Set diagnostic loclist"))

-- Lspsaga キーマッピング
vim.keymap.set("n", "<leader>lf", "<cmd>Lspsaga finder<cr>", ex_opts("Lspsaga Finder show references"))
vim.keymap.set("n", "<leader>lh", "<cmd>Lspsaga hover_doc<cr>", ex_opts("Lspsaga Hover Doc"))
vim.keymap.set("n", "<leader>lo", "<cmd>Lspsaga outline<cr>", ex_opts("Lspsaga Outline"))
vim.keymap.set("n", "<leader>lr", "<cmd>Lspsaga rename<cr>", ex_opts("Lspsaga Rename"))
vim.keymap.set("n", "<leader>la", "<cmd>Lspsaga code_action<cr>", ex_opts("Lspsaga Code Action"))
vim.keymap.set("n", "<leader>lp", "<cmd>Lspsaga peek_definition<cr>", ex_opts("Lspsaga Peek Definition"))

-- neotree diagnostic
vim.keymap.set("n", "<leader>nd", ":Neotree diagnostics reveal bottom<CR>", ex_opts("Open diagnostic bottom"))

-- toggleterm
local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({ cmd = "lazygit", hidden = true })

function _lazygit_toggle()
  lazygit:toggle()
end

local htopgit = Terminal:new({ cmd = "htop", hidden = true })
function _htop_toggle()
  htopgit:toggle()
end

vim.api.nvim_set_keymap("n", "<leader>g", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>h", "<cmd>lua _htop_toggle()<CR>", { noremap = true, silent = true })

-- インサートモードの括弧の自動補完
vim.keymap.set("i", "(", "()<Left>")
vim.keymap.set("i", "[", "[]<Left>")
vim.keymap.set("i", "{", "{}<Left>")

vim.keymap.set("i", "<C-h>", "<Left>", opts)
vim.keymap.set("i", "<C-j>", "<Down>", opts)
vim.keymap.set("i", "<C-k>", "<Up>", opts)
vim.keymap.set("i", "<C-l>", "<Right>", opts)
vim.keymap.set("i", "<C-a>", "<Home>", opts)
vim.keymap.set("i", "<C-e>", "<End>", opts)
vim.keymap.set("i", "<C-u>", "<C-o>d0", opts)
vim.keymap.set("i", "<C-w>", "<C-o>dB", opts)
vim.keymap.set("i", "<C-i>", "<Esc>O", opts)
vim.keymap.set("i", "<C-o>", "<Esc>o", opts)

--ターミナルモード
vim.keymap.set("t", "<leader><Esc>", "<C-\\><C-n>", opts)

--ビジュアルモード
vim.keymap.set("v", "<C-k>", "5k", opts)
vim.keymap.set("v", "<C-j>", "5j", opts)
