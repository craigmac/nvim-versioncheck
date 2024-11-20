rockspec_format = '3.0'
package = "nvim-versioncheck"
version = "scm-1"
source = {
  -- TODO: Update this URL
  url = "git+https://github.com/craigmac/nvim-versioncheck"
}
dependencies = {
  -- Add runtime dependencies here
  -- e.g. "plenary.nvim",
}
test_dependencies = {
  "nlua"
}
build = {
  type = "builtin",
  copy_directories = {
    -- Add runtimepath directories, like
    -- 'plugin', 'ftplugin', 'doc'
    -- here. DO NOT add 'lua' or 'lib'.
  },
}
