-- Neovim entry point.
--
-- Bootstrap lazy.nvim, load the plugin specs from lua/plugins/, then apply the
-- core options, keymaps and autocmds.

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- nvim-tree replaces netrw's browser; disable it before anything loads it.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n" .. out, "ErrorMsg" },
    }, true)
  end
end

vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  change_detection = { notify = false },
})

require("options")
require("keymaps")
require("autocmds")