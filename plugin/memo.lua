if vim.g.loaded_memo == 1 then
  return
end
vim.g.loaded_memo = 1

local core = require("memo.core")
local help = require("memo.help")

vim.api.nvim_create_user_command("MemoNew", function()
  core.create_new_memo()
end, { desc = "Create a new memo" })

vim.api.nvim_create_user_command("MemoHelp", function()
  help.show_help()
end, { desc = "Show markdown cheat sheet" })
