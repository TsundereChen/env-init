-- Autocommands. The old vimrc opened NERDTree on launch; the modern equivalent
-- lives in the nvim-tree spec, so this file covers editor behaviour only.

local augroup = vim.api.nvim_create_augroup("User Autocmds", { clear = true })

-- Trim trailing whitespace on save, keeping the cursor column honest.
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup,
  pattern = "*",
  callback = function()
    local view = vim.fn.winsaveview()
    vim.cmd("keeppatterns %s/\\s\\+$//e")
    vim.fn.winrestview(view)
  end,
})

-- Close scratch/terminal buffers with a single key.
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = {
    "qf",
    "help",
    "man",
    "marks",
    "floaterm",
    "lspinfo",
    "TelescopePrompt",
  },
  callback = function(ev)
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = ev.buf, silent = true })
  end,
})

-- Markdown reads better wrapped, with the source URL hidden.
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "markdown", "mdx" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.conceallevel = 2
  end,
})

-- YAML and shell scripts want spaces, not tabs.
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "yaml", "sh", "bash", "zsh", "fish" },
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})

-- Treesitter highlighting and indentation. The nvim-treesitter rewrite on the
-- `main` branch leaves both to the user, and enabling them per filetype means
-- files without a matching parser fall back to regular syntax highlighting.
local ts_langs = {
  bash = "bash",
  css = "css",
  html = "html",
  javascript = "javascript",
  javascriptreact = "javascript",
  json = "json",
  lua = "lua",
  markdown = "markdown",
  python = "python",
  query = "query",
  toml = "toml",
  typescript = "typescript",
  typescriptreact = "tsx",
  vim = "vim",
  yaml = "yaml",
}

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = vim.tbl_keys(ts_langs),
  callback = function(ev)
    local lang = ts_langs[ev.match]
    local ok, parser = pcall(vim.treesitter.language.add, lang)
    if not ok then
      return
    end

    vim.treesitter.start(ev.buf, lang)
    vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
