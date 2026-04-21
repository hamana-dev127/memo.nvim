local config = require("memo.config")
local keymaps = require("memo.keymaps")

local M = {}

local function expand_dir(dir)
  return vim.fn.expand(dir)
end

function M.create_new_memo()
  vim.ui.input({ prompt = "Memo name (e.g., 'memo' or 'dir/memo'): " }, function(input)
    if not input or input == "" then
      return
    end

    -- Add default extension if not provided
    if not input:match("%.[%w]+$") then
      input = input .. config.options.default_ext
    end

    local dir = expand_dir(config.options.memo_dir)
    
    local filepath
    -- Check if input is an absolute path or starts with ~
    if input:match("^/") or input:match("^~") then
      filepath = expand_dir(input)
    else
      filepath = dir .. "/" .. input
    end
    
    -- Extract the target directory path
    local target_dir = vim.fn.fnamemodify(filepath, ":h")

    -- Create directory if it doesn't exist
    if vim.fn.isdirectory(target_dir) == 0 then
      vim.fn.mkdir(target_dir, "p")
    end

    local final_path = filepath
    
    -- Open the file in a new buffer
    vim.cmd("edit " .. vim.fn.fnameescape(final_path))
    
    -- Setup buffer-local keymaps for the newly opened memo
    keymaps.setup_buffer()
  end)
end

return M
