-- vim: ft=lua tw=80
stds.nvim = {
  read_globals = { "jit" }
}
std = "lua51+nvim"

-- Don't report unused self arguments of methods.
self = false

ignore = {
  "631",  -- max_line_length
  "212/_.*",  -- unused argument, for vars with "_" prefix
  "214", -- used variable with unused hint ("_" prefix)
  "121", -- setting read-only global variable 'vim'
  "122", -- setting read-only field of global variable 'vim'
  "581", -- negation of a relational operator- operator can be flipped (not for tables)
}

read_globals = {
  "vim",
  "describe",
  "it",
  "assert"
}

globals = {
  "vim.g",
  "vim.b",
  "vim.w",
  "vim.o",
  "vim.bo",
  "vim.wo",
  "vim.go",
  "vim.env"
}
