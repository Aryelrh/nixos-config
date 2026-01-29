-- modules/home/nvim/init.lua
vim.g.mapleader = " "
vim.opt.termguicolors = true

-- Forces lockfile to a mutable directory before bootstrap
vim.g.lazy_lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json"

-- Bootstrap Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Config base
require("config.options")
require("config.keymaps")

-- Load plugins
require("config.lazy")
