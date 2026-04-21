local M = {}

local cheat_sheet_content = {
  "# 📝 Markdown 書き方早見表",
  "",
  "## 📌 見出し",
  "```text",
  "# 大見出し (H1)",
  "## 中見出し (H2)",
  "### 小見出し (H3)",
  "```",
  "",
  "## 📝 箇条書き",
  "【書き方】",
  "```text",
  "- 箇条書き 1",
  "  - 階層を下げる時は行頭でTab",
  "  - もう一度Tabを押すと「→」になる",
  "- 箇条書き 2",
  "```",
  "【見え方】",
  "- 箇条書き 1",
  "  - 階層を下げる時は行頭でTab",
  "  - もう一度Tabを押すと「→」になる",
  "- 箇条書き 2",
  "",
  "## 🔢 番号付きリスト",
  "```text",
  "1. 手順 1",
  "2. 手順 2",
  "3. 手順 3",
  "```",
  "",
  "## 💬 引用",
  "【書き方】",
  "```text",
  "> 重要なポイントや",
  "> 引用したい文章はこれを使います。",
  "```",
  "【見え方】",
  "> 重要なポイントや",
  "> 引用したい文章はこれを使います。",
  "",
  "## 📊 表 (テーブル)",
  "【書き方】",
  "```text",
  "| 見出し1 | 見出し2 | 見出し3 |",
  "| :--- | :---: | ---: |",
  "| 左寄せ | 中央寄せ | 右寄せ |",
  "| りんご | 100円 | 3個 |",
  "```",
  "【見え方】",
  "| 見出し1 | 見出し2 | 見出し3 |",
  "| :--- | :---: | ---: |",
  "| 左寄せ | 中央寄せ | 右寄せ |",
  "| りんご | 100円 | 3個 |",
  "",

  "## ✒️ 文字の装飾",
  "【書き方】",
  "```text",
  "**太字にしたい文字**",
  "*斜体にしたい文字*",
  "~~取り消し線~~",
  "`短いコードや強調`",
  "```",
  "【見え方】",
  "**太字にしたい文字**",
  "*斜体にしたい文字*",
  "~~取り消し線~~",
  "`短いコードや強調`",
  "",
  "## 💻 コードブロック",
  "【書き方】",
  "````text",
  "```python",
  "def hello():",
  "    print('Hello, Memo!')",
  "```",
  "````",
  "【見え方】",
  "```python",
  "def hello():",
  "    print('Hello, Memo!')",
  "```",
  "",
  "## 🔗 リンク",
  "【書き方】",
  "```text",
  "[Googleへのリンク](https://google.com)",
  "```",
  "【見え方】",
  "[Googleへのリンク](https://google.com)",
}

function M.show_help()
  local buf = vim.api.nvim_create_buf(false, true)
  
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, cheat_sheet_content)
  
  vim.cmd("vsplit")
  vim.cmd("wincmd L")
  
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(win, buf)
  vim.api.nvim_win_set_width(win, 50)
  
  vim.bo[buf].filetype = "markdown"
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = "wipe"
  
  vim.keymap.set("n", "q", ":q<CR>", { buffer = buf, silent = true, noremap = true })
end

return M
