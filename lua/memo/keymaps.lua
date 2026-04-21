local M = {}

local last_tab_time = 0

function M.setup_buffer()
  local bufnr = vim.api.nvim_get_current_buf()

  -- Handle Double Tab for '→'
  vim.keymap.set("i", "<Tab>", function()
    -- If pumvisible (completion menu), fallback
    if vim.fn.pumvisible() == 1 then
      return "<Tab>"
    end

    local now = vim.uv.now()
    local is_double = (now - last_tab_time) < 300
    last_tab_time = now

    if is_double then
      local sw = vim.fn.shiftwidth()
      if sw == 0 then sw = 2 end
      local bs = string.rep("<BS>", sw)
      return bs .. "→ "
    end

    return "<Tab>"
  end, { buffer = bufnr, expr = true, replace_keycodes = true, desc = "Smart Tab for Memo" })

  -- Handle Enter (Auto-indent for '→')
  vim.keymap.set("i", "<CR>", function()
    if vim.fn.pumvisible() == 1 then
      return "<CR>"
    end

    local line = vim.api.nvim_get_current_line()
    -- Match lines starting with whitespace, then '→', then whitespace
    local indent, arrow_spaces = line:match("^(%s*)→(%s*)")
    
    if indent and arrow_spaces then
      local arrow_width = vim.fn.strdisplaywidth("→")
      local total_spaces = string.len(indent) + arrow_width + string.len(arrow_spaces)
      return "<CR>" .. string.rep(" ", total_spaces)
    end

    return "<CR>"
  end, { buffer = bufnr, expr = true, replace_keycodes = true, desc = "Smart Enter for Memo" })
end

return M
