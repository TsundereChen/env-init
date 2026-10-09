-- Global keymaps, ported from the old vimrc and remapped onto the new plugins.
--
-- Mappings for plugins that own their own keys (nvim-tree, easy-align) are set
-- in the plugin specs, so everything else lives here.

local map = vim.keymap.set

-- Clipboard (macOS uses the "+" clipboard register)
map({ "n", "x" }, "Y", '"+y')
map({ "n", "x" }, "P", '"+p')

-- Clear the search highlight on <CR> (was in the old vimrc)
map("n", "<CR>", "<cmd>nohlsearch<CR>")

-- <Space> toggles the fold under the cursor
map("n", "<Space>", function()
  if vim.fn.foldlevel(".") > 0 then
    vim.cmd("normal! za")
  else
    vim.cmd("normal! zv")
  end
end, { silent = true })
map("x", "<Space>", "zf")

-- Tab navigation (was <C-t>{n,c,j,k})
map("n", "<C-t>n", "<cmd>tabnew<CR>")
map("n", "<C-t>c", "<cmd>tabclose<CR>")
map("n", "<C-t>j", "<cmd>tabprevious<CR>")
map("n", "<C-t>k", "<cmd>tabnext<CR>")
map("n", "<C-t>", "<cmd>tabnew<CR>")

-- Paste toggle (was <F2> pastetoggle/invpaste)
map({ "n", "i", "c", "v" }, "<F2>", function()
  vim.opt.paste = not vim.opt.paste:get()
end, { silent = true })

-- Window movement (also the built-in default, kept explicit for clarity)
map("n", "<C-h>", "<C-w><C-h>")
map("n", "<C-j>", "<C-w><C-j>")
map("n", "<C-k>", "<C-w><C-k>")
map("n", "<C-l>", "<C-w><C-l>")

-- Split navigation
map("n", "<C-h><C-h>", "<C-w>h")
map("n", "<C-j><C-j>", "<C-w>j")
map("n", "<C-k><C-k>", "<C-w>k")
map("n", "<C-l><C-l>", "<C-w>l")

-- Flash (replaces vim-easymotion). These mirror the old easymotion keys:
--   <Leader><Leader>f -> <leader>f  jump to a character
--   s                -> <leader>s  jump to a two-character sequence
--   <Leader><Leader>L-> <leader>L  jump to a line
--   <Leader><Leader>w-> <leader>w  jump to a word
map({ "n", "x", "o" }, "<leader>f", function()
  require("flash").jump()
end, { desc = "Flash jump" })

map({ "n", "x", "o" }, "<leader>s", function()
  require("flash").jump()
end, { desc = "Flash jump (long labels)" })

map({ "n", "x", "o" }, "<leader>w", function()
  require("flash").jump({ pattern = vim.fn.expand("<cword>") })
end, { desc = "Flash jump to word" })

map({ "n", "x", "o" }, "<leader>L", function()
  require("flash").jump({
    pattern = "^",
    search = { mode = "search", max_length = 0 },
    label = { after = { 0, 0 } },
  })
end, { desc = "Flash jump to line" })

map({ "n", "x", "o" }, "<leader>n", function()
  require("flash").jump({ pattern = "[^[:space:]]" })
end, { desc = "Flash jump to non-blank" })

map({ "n", "x", "o" }, "S", function()
  require("flash").treesitter()
end, { desc = "Flash treesitter selection" })
