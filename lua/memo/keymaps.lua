local M = {}

local last_tab_time = 0

function M.setup_buffer()
  local bufnr = vim.api.nvim_get_current_buf()

  -- Turn off spellcheck while memo is active
  vim.bo[bufnr].spell = false

  -- Auto show help if configured
  if require("memo.config").options.auto_show_help then
    require("memo.help").show_help()
    vim.cmd("wincmd p") -- return focus to memo buffer
  end

  -- Handle Smart Tab
  vim.keymap.set("i", "<Tab>", function()
    if vim.fn.pumvisible() == 1 then
      return "<Tab>"
    end

    local line = vim.api.nvim_get_current_line()
    local col = vim.fn.col('.') - 1
    local prefix = string.sub(line, 1, col)

    -- 0. Table Navigation
    if line:match("^%s*|") then
        local next_p = line:find("|", col + 1)
        if next_p and next_p == col + 1 then
            next_p = line:find("|", col + 2)
        end
        if next_p then
            vim.schedule(function()
                local r = vim.fn.line('.')
                local target_col = next_p
                if line:sub(target_col + 1, target_col + 1) == " " then
                    target_col = target_col + 1
                end
                vim.api.nvim_win_set_cursor(0, {r, target_col})
            end)
            return ""
        end
    end

    local now = vim.uv.now()
    local is_double = (now - last_tab_time) < 300
    last_tab_time = now

    -- 1. Double Tab
    if is_double then
      if prefix:match("^%s*%- $") then
        return "<BS><BS>→ "
      end
      if prefix:match("^%s*[%-%*%+]%s") then
        vim.schedule(function()
          local l = vim.api.nvim_get_current_line()
          local r, c = unpack(vim.api.nvim_win_get_cursor(0))
          local sw = vim.fn.shiftwidth()
          if sw == 0 then sw = 2 end
          local new_l = l:gsub("^" .. string.rep(" ", sw), "")
          new_l = new_l:gsub("^(%s*)[%-%*%+]%s", "%1→ ")
          vim.api.nvim_set_current_line(new_l)
          vim.api.nvim_win_set_cursor(0, {r, math.max(0, c - sw + 2)})
        end)
        return ""
      end
      return "<Tab>"
    end

    -- 2. Single Tab
    if prefix:match("^%s*$") then return "- " end
    if prefix:match("^%s*[%-%*%+]%s") or prefix:match("^%s*%d+%.%s") then return "<C-t>" end
    return "<Tab>"
  end, { buffer = bufnr, expr = true, replace_keycodes = true, desc = "Smart Tab for Memo" })

  -- Handle Enter (Auto-indent, Auto-list, Auto-table)
  vim.keymap.set("i", "<CR>", function()
    if vim.fn.pumvisible() == 1 then return "<CR>" end

    local line = vim.api.nvim_get_current_line()
    local col = vim.fn.col('.') - 1
    local prefix = string.sub(line, 1, col)

    -- 1. Table Auto-continue
    if prefix:match("^%s*|.*|$") or prefix:match("^%s*|.*|%s*$") then
        local content = line:gsub("|", ""):gsub("%s", ""):gsub("%-", "")
        if content == "" and line:match("|") then
            return "<C-u><CR>" -- Exit table
        end
        local count = 0
        for _ in prefix:gmatch("|") do count = count + 1 end
        if count >= 2 then
            local indent = prefix:match("^(%s*)")
            local next_line = indent .. "|"
            for i = 1, count - 1 do next_line = next_line .. "  |" end
            vim.schedule(function()
                local r = vim.api.nvim_win_get_cursor(0)[1]
                vim.api.nvim_set_current_line(next_line)
                vim.api.nvim_win_set_cursor(0, {r, #indent + 2})
            end)
            return "<CR>"
        end
    end

    -- 2. Numbered List Auto-continue
    local num_indent, num = prefix:match("^(%s*)(%d+)%.%s+")
    if num_indent and num then
        if prefix:match("^%s*%d+%.%s*$") and col == #line then return "<C-u><CR>" end
        local next_num = tostring(tonumber(num) + 1)
        local next_line = num_indent .. next_num .. ". "
        vim.schedule(function()
            local r = vim.api.nvim_win_get_cursor(0)[1]
            vim.api.nvim_set_current_line(next_line)
            vim.api.nvim_win_set_cursor(0, {r, #next_line})
        end)
        return "<CR>"
    end

    -- 3. Bullet List Auto-continue
    local bullet_indent, bullet = prefix:match("^(%s*)([%-%*%+])%s+")
    if bullet_indent and bullet then
        if prefix:match("^%s*[%-%*%+]%s*$") and col == #line then return "<C-u><CR>" end
        local next_line = bullet_indent .. bullet .. " "
        vim.schedule(function()
            local r = vim.api.nvim_win_get_cursor(0)[1]
            vim.api.nvim_set_current_line(next_line)
            vim.api.nvim_win_set_cursor(0, {r, #next_line})
        end)
        return "<CR>"
    end

    -- 4. Arrow Auto-indent
    local arrow_indent, arrow_spaces = prefix:match("^(%s*)→(%s*)")
    if arrow_indent and arrow_spaces then
        if prefix:match("^%s*→%s*$") and col == #line then return "<C-u><CR>" end
        local arrow_width = vim.fn.strdisplaywidth("→")
        local total_spaces = string.len(arrow_indent) + arrow_width + string.len(arrow_spaces)
        local next_line = string.rep(" ", total_spaces)
        vim.schedule(function()
            local r = vim.api.nvim_win_get_cursor(0)[1]
            vim.api.nvim_set_current_line(next_line)
            vim.api.nvim_win_set_cursor(0, {r, #next_line})
        end)
        return "<CR>"
    end

    return "<CR>"
  end, { buffer = bufnr, expr = true, replace_keycodes = true, desc = "Smart Enter for Memo" })
end

function M.teardown_buffer()
  local bufnr = vim.api.nvim_get_current_buf()
  pcall(vim.keymap.del, "i", "<Tab>", { buffer = bufnr })
  pcall(vim.keymap.del, "i", "<CR>", { buffer = bufnr })
  vim.bo[bufnr].spell = true
end

return M
