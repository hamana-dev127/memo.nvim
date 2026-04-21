if vim.g.loaded_memo == 1 then
  return
end
vim.g.loaded_memo = 1

local core = require("memo.core")
local help = require("memo.help")

vim.api.nvim_create_user_command("MemoNew", function()
  core.create_new_memo()
end, { desc = "Create a new memo" })

vim.api.nvim_create_user_command("MemoEnable", function()
  require("memo.keymaps").setup_buffer()
  vim.notify("Memo.nvim: 現在のバッファで入力アシストが有効になりました！", vim.log.levels.INFO)
end, { desc = "Enable Memo keymaps for current buffer" })

vim.api.nvim_create_user_command("MemoHelp", function()
  help.show_help()
end, { desc = "Show markdown cheat sheet" })
