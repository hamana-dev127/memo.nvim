local M = {}

M.options = {
  memo_dir = vim.fn.getcwd(),
  default_ext = ".md",
}

function M.setup(opts)
  M.options = vim.tbl_deep_extend("force", M.options, opts or {})
end

return M
