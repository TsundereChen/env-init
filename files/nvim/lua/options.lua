-- Core options, ported from the old Vundle-era vimrc.

local opt = vim.opt

-- Encoding / display
opt.encoding = "utf-8"
opt.termguicolors = true
opt.ttyfast = true
opt.list = true
opt.listchars = { tab = "› ", trail = "•", extends = "#", nbsp = "." }
opt.number = true
opt.relativenumber = false

-- Editing
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.formatoptions = "tcqrnl"
opt.matchpairs:append("<:>")
opt.backspace = "indent,eol,start"

-- Cursor / scrolling
opt.scrolloff = 5

-- Searching: same behaviour as the old vimrc
opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- Statusline / messages
opt.showmode = true
opt.showcmd = true
opt.splitbelow = true
opt.splitright = true
opt.confirm = true

-- Completion behaviour. nvim-cmp drives the sources, these tune the editor.
opt.completeopt = { "menu", "menuone", "noselect" }
opt.pumheight = 10

-- Long lines stay unwrapped so the cursor never jumps off-screen
opt.wrap = false
opt.breakindent = true