-- NeoTreeのデフォルト設定
-- local vim = require("vim")
vim.cmd([[
  let g:neo_tree_remove_legacy_commands = 1
  autocmd VimEnter * Neotree left
]])
--
vim.opt.updatetime = 250 -- `CursorHold` の発火時間を短縮（デフォルトは 4000ms）
vim.api.nvim_create_autocmd("CursorHold", {
  pattern = "*",
  callback = function()
    vim.diagnostic.open_float(nil, { focusable = false, border = "rounded" })
  end,
})
-- tsc のエラーを保持するための Neovim 診断用ネームスペースを作成
local tsc_ns = vim.api.nvim_create_namespace("my-tsc-diagnostics")

-- tsc の出力を解析して、ファイルごとのエラーをまとめる関数
local function parse_tsc_output(output_lines)
  -- 結果を格納するテーブル
  --   diag_by_file[bufnr] = { { message=..., lnum=..., col=..., severity=...}, ... }
  local diag_by_file = {}

  for index, line in ipairs(output_lines) do
    -- 例: src/foo.ts(10,5): error TS1005: ';' expected.
    --     ^^^^^^^^^^^^^^^^ filename(lnum,col)
    -- capture用に単純な正規表現を使用
    local pattern = "^(.-)%((%d+),(%d+)%)%: (.+)$"
    local filename, lnum, col, msg = line:match(pattern)

    if filename and lnum and col and msg then
      -- フルパス or 相対パスをどう扱うかは環境次第
      -- とりあえず expand() でフルパス化して bufexists できるようにする
      local fullpath = vim.fn.fnamemodify(filename, ":p")
      local bufnr = vim.fn.bufnr(fullpath, false) == -1 and vim.fn.bufadd(fullpath)
          or vim.fn.bufnr(fullpath, false)

      if bufnr ~= -1 then
        -- Neovim の診断オブジェクトを作成
        local diag = {
          lnum = tonumber(lnum) - 1,           -- Neovimは0-index、tsc出力は1-index
          col = tonumber(col) - 1,
          severity = vim.diagnostic.severity.ERROR, -- ここでは無条件で Error 扱い
          source = "tsc",
          message = msg,                       -- 実際は "error TS1005: ';' expected." が丸ごと入る
        }
        -- 同じファイルの診断をまとめてテーブルに格納
        diag_by_file[bufnr] = diag_by_file[bufnr] or {}
        table.insert(diag_by_file[bufnr], diag)
      else
        local bufnr = vim.fn.bufadd(fullpath)
        local diag = {
          lnum = tonumber(lnum) - 1,           -- Neovimは0-index、tsc出力は1-index
          col = tonumber(col) - 1,
          severity = vim.diagnostic.severity.ERROR, -- ここでは無条件で Error 扱い
          source = "tsc",
          message = msg,                       -- 実際は "error TS1005: ';' expected." が丸ごと入る
        }
        -- 同じファイルの診断をまとめてテーブルに格納
        diag_by_file[bufnr] = diag_by_file[bufnr] or {}
        table.insert(diag_by_file[bufnr], diag)
      end
    end
  end
  return diag_by_file
end

-- ファイル保存後に tsc --noEmit を実行して、診断情報を更新するAutocmd
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
  callback = function()
    -- tsc --noEmit を実行
    local output = vim.fn.systemlist("tsc --noEmit")

    -- まず古い診断をクリア（前回の結果を消す）
    vim.diagnostic.reset(tsc_ns)

    -- 出力が「エラー0件 / 全て成功」的な場合は output テーブルが空、またはメッセージのみ
    -- 下記の parse 処理で何も該当しなければ診断はそのまま空になります
    local diag_by_file = parse_tsc_output(output)

    -- ファイルごとに診断をセット
    for bufnr, diags in pairs(diag_by_file) do
      vim.diagnostic.set(tsc_ns, bufnr, diags)
    end
  end,
})

vim.api.nvim_create_autocmd("VimLeave", {
  pattern = "*",
  command = "set guicursor=a:ver20",
})
