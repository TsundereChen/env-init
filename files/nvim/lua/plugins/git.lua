-- Search, git and the file tree.

return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = { "nvim-lua/plenary.nvim" },
    -- Declared via `keys` rather than inside config(), so lazy.nvim owns the
    -- keymaps and loads telescope on first press. Setting keymaps in config()
    -- would be circular: config() only runs once telescope is already loaded.
    keys = {
      { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Files" },
      { "<leader>fg", function() require("telescope.builtin").live_grep() end, desc = "Live grep" },
      { "<leader>fb", function() require("telescope.builtin").buffers() end, desc = "Buffers" },
      { "<leader>fr", function() require("telescope.builtin").oldfiles() end, desc = "Recent files" },
      { "<leader>fc", function() require("telescope.builtin").commands() end, desc = "Commands" },
      { "<leader>fh", function() require("telescope.builtin").help_tags() end, desc = "Help tags" },
      { "<leader>fs", function() require("telescope.builtin").grep_string() end, desc = "Grep string under cursor" },
      { "<leader>fd", function() require("telescope.builtin").lsp_document_symbols() end, desc = "Document symbols" },
      { "<leader>fq", function() require("telescope.builtin").resume() end, desc = "Resume last picker" },
    },
    config = function()
      require("telescope").setup({
        defaults = {
          prompt_prefix = "> ",
          selection_caret = " ",
          sorting_strategy = "ascending",
          layout_strategy = "horizontal",
          path_display = { "smart" },
          file_ignore_patterns = {
            "^.git/",
            "%.swp$",
            "__pycache__",
            "node_modules",
          },
        },
        pickers = {
          find_files = { hidden = true },
          live_grep = { additional_args = { "--hidden" } },
          buffers = {
            sort_mru = true,
            ignore_current_buffer = true,
          },
        },
      })
    end,
  },

  {
    "tpope/vim-fugitive",
    cmd = {
      "Git",
      "Gd",
      "Gl",
      "Ga",
      "Go",
      "Gremove",
      "Gdelete",
      "Gcommit",
      "Gcommitamend",
      "Gstatus",
      "Glog",
      "Gblame",
      "Gbrowse",
      "Ggrep",
      "Gedit",
      "Gshow",
      "Gdiff",
      "Gsplit",
      "Gvsplit",
    },
    init = function()
      vim.g.fugitive_sort_mru = true
      vim.g.fugitive_pretty_diff = true
      vim.g.fugitive_refresh_always = false
    end,
  },

  {
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    config = function()
      require("nvim-tree").setup({
        -- nvim-tree takes over netrw's job
        disable_netrw = true,
        hijack_netrw = true,
        git = {
          enable = true, -- replaces Xuyuanp/nerdtree-git-plugin
          timeout = 1000,
        },
        filters = {
          -- .gitignore is respected by default; dotfiles are hidden
          dotfiles = true,
          git_ignored = true,
        },
        view = {
          width = 30,
          side = "left",
          cursorline = true,
        },
        diagnostics = {
          enable = true,
        },
        update_focused_file = {
          enable = true,
          update_root = { enable = true },
        },
        on_attach = function(bufnr)
          local api = require("nvim-tree.api")

          local function opts(desc)
            return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
          end

          -- Start from the documented defaults, then add the tree-local keys
          -- the old NERDTree setup provided.
          api.map.on_attach.default(bufnr)

          vim.keymap.set("n", "<C-t>", api.tree.change_root_to_parent, opts("Up"))
          vim.keymap.set("n", "<C-]>", api.tree.change_root_to_node, opts("CD"))
          vim.keymap.set("n", "gd", api.node.navigate.diagnostics.next, opts("Next Diagnostic"))
          vim.keymap.set("n", "ge", api.fs.copy.basename, opts("Copy Basename"))
        end,
      })

      -- The old vimrc mapped <C-n> to :NERDTreeToggle
      vim.keymap.set("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file tree" })

      -- ...and opened NERDTree on startup when invoked with no arguments
      -- (autocmd VimEnter * if argc() == 0 | NERDTree | endif).
      if vim.fn.argc() == 0 and vim.fn.isdirectory(vim.fn.getcwd()) then
        vim.defer_fn(function()
          require("nvim-tree.api").tree.open()
        end, 150)
      end
    end,
  },

  {
    "folke/flash.nvim",
    event = "VeryLazy",
    config = function()
      require("flash").setup({
        -- Make / and ? show jump labels too, like the old
        -- `map / <Plug>(easymotion-sn)` mapping did.
        modes = {
          search = { enabled = true },
        },
      })
    end,
  },

  {
    "junegunn/vim-easy-align",
    cmd = "EasyAlign",
    keys = {
      { "ga", "<Plug>(EasyAlign)", mode = { "n", "x" }, remap = true, desc = "Align text" },
    },
  },
}
