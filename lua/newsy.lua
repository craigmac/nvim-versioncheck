--- @brief
--- nvim-newsy is a plugin that is only enabled on prerelease ("nightly")
--- builds. It's meant to help those tracking Nvim HEAD see what, if anything,
--- has changed in the runtime news.txt file since the last time nvim was
--- started.

--- @brief [g:nvim_newsy]()
---
--- nvim-news is enabled by default on prerelease ("nightly") builds.
--- To disable it, add to your config:
---
--- ```lua
--- vim.g.nvim_newsy = false
--- ```
local M = {}

--- Write runtime news.txt file to cache
local function write_news_to_cache()
  local cache_fh, err = io.open(vim.fs.normalize(vim.fn.stdpath('state') .. '/news.txt'), 'w+')
  if err then error(err) end

  local news_fh, err = io.open(vim.fs.normalize('$VIMRUNTIME/doc/news.txt'))
  if err then error(err) end

  local news = news_fh:read('*a')
  if news then cache_fh:write(news) end

  cache_fh:close()
  news_fh:close()
end

---@return boolean
local function hashes_match()
  local current_fh, err = io.open(vim.fs.normalize('$VIMRUNTIME/doc/news.txt'))
  if err then error(err) end

  local cached_fh, err = io.open(vim.fs.normalize(vim.fn.stdpath('state') .. '/news.txt'))
  if err then error(err) end

  local current_hash = vim.fn.sha256(current_fh:read('*a'))
  local cached_hash = vim.fn.sha256(cached_fh:read('*a'))

  current_fh:close()
  cached_hash:close()
  return current_hash == cached_hash
end

---@return boolean
local function user_wants_diff()
  local result = vim.fn.confirm('VersionCheck: news file changed - view changes?', '&yes\n&no', 1)
  return result == 1
end

local function show_news_diff()
  vim.cmd.tabedit(vim.fs.normalize('$VIMRUNTIME/doc/news.txt'))
  vim.cmd.diffsplit(vim.fs.normalize(vim.fn.stdpath('state') .. '/news.txt'))
end

function M.check_for_news()
  -- * get current vim.version()
  -- * get cached vim.version():
  --   A. no cached version:
  --      ** set cached version equal to the current version value
  --      ** write the runtime news.txt file to cache
  --      ** return
  --    B. existing cache version:
  --      ** cache version is less than current version:
  --      ** cache version equal to current version:
  --        *** but do hashes match?
  --          **** yes -> return, nothing to report
  --          **** no -> report to user news.txt has changed
  local current_version = vim.version()

  if not vim.g.NVIM_VERSION then
    vim.g.NVIM_VERSION = current_version
    write_news_to_cache()
    return
  end

  if vim.version.lt(vim.g.NVIM_VERSION, current_version) then
    vim.g.NVIM_VERSION = current_version
    if user_wants_diff() then show_news_diff() end
  elseif vim.version.eq(vim.g.NVIM_VERSION, current_version) then
    if hashes_match() then return end
  else
    -- odd case: cache version is greater than current version, maybe
    -- user switched nvim versions or there's a bug

  end

end

return M
