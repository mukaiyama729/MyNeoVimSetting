local ext_with_commentout = {
  py = "#",
  lua = "--",
  ts = "//",
  java = "//",
}

local M = {}
M.config = {
  enable = true,
  auto_save_timers = {},
  save_time_span = 720000,
}

M.setup = function(opts)
  M.config = vim.tbl_extend("force", M.config, opts or {})
  local group = vim.api.nvim_create_augroup("MyToggle", { clear = true })
  local patterns = {}

  for ext, _ in pairs(ext_with_commentout) do
    table.insert(patterns, "*." .. ext)
  end

  vim.api.nvim_create_autocmd({ "BufReadPost" }, {
    group = group,
    pattern = patterns,
    callback = function()
      M.toggle_auto_save()
    end,
  })

  vim.api.nvim_create_autocmd({ "BufUnload", "BufDelete" }, {
    group = group,
    pattern = patterns,
    callback = function(event)
      local buf_num = event.buf
      print("Auto save stopping for buffer " .. buf_num)
      if M.config.auto_save_timers[buf_num] ~= nil then
        M.config.auto_save_timers[buf_num]:stop()
        M.config.auto_save_timers[buf_num]:close()
        M.config.auto_save_timers[buf_num] = nil
        print("Auto save stopped for buffer " .. buf_num)
      end
    end,
  })
end

M.get_ext = function()
  local file_name = vim.api.nvim_buf_get_name(0)
  local ext = file_name:match("^.+%.(.+)$")
  return ext
end

M.toggle_comment = function()
  local cmt_out = ext_with_commentout[M.get_ext()]
  if cmt_out == nil then
    return
  end
  local ln_num = vim.fn.line(".") - 1
  local ln_content = vim.api.nvim_get_current_line()
  local safe_cmt_out = cmt_out:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1")
  local pattern = "^(%s*)" .. string.format("(%s)(.*)$", safe_cmt_out)
  local indent, comment_out, ln_sentence = ln_content:match(pattern)
  vim.api.nvim_buf_set_lines(
    0,
    ln_num,
    ln_num + 1,
    false,
    { comment_out == nil and cmt_out .. ln_content or indent .. ln_sentence }
  )
end

M.toggle_auto_save = function()
  local current_buf_num = vim.api.nvim_get_current_buf()

  if M.config.auto_save_timers[current_buf_num] ~= nil then
    return
  end

  local timer = vim.loop.new_timer()
  timer:start(
    0,
    M.config.save_time_span,
    vim.schedule_wrap(function()
      if M.config.enable and vim.bo.modified then
        print("Auto-saving buffer: " .. current_buf_num) -- デバッグ
        vim.api.nvim_command("write")
      end
    end)
  )
  M.config.auto_save_timers[current_buf_num] = timer
end

M.debug = function()
  print(vim.inspect(M))
end

return M
