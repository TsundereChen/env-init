-- LSP, completion and Treesitter. Replaces YouCompleteMe.
--
-- Language servers are installed and enabled by Mason; completion is driven by
-- nvim-cmp on top of Neovim's built-in LSP client.

return {
  -- Language servers ------------------------------------------------------

  {
    "mason-org/mason.nvim",
    lazy = false,
    cmd = { "Mason", "MasonInstall", "MasonUninstall" },
    config = function()
      require("mason").setup()

      -- Make the LSP keymaps available as soon as a server attaches.
      local map = vim.keymap.set

      map("n", "gd", vim.lsp.buf.definition, { desc = "LSP go to definition" })
      map("n", "gD", vim.lsp.buf.declaration, { desc = "LSP go to declaration" })
      map("n", "gr", vim.lsp.buf.references, { desc = "LSP list references" })
      map("n", "K", vim.lsp.buf.hover, { desc = "LSP hover" })
      map("n", "<leader>lr", function()
        vim.lsp.buf.rename()
      end, { desc = "LSP rename symbol" })
      map("n", "<leader>la", vim.lsp.buf.code_action, { desc = "LSP code action" })
      map({ "n", "v" }, "<leader>lf", function()
        vim.lsp.buf.format({ async = true })
      end, { desc = "LSP format buffer" })
      map("n", "[d", function()
        vim.diagnostic.jump({ count = -1, float = true })
      end, { desc = "Previous diagnostic" })
      map("n", "]d", function()
        vim.diagnostic.jump({ count = 1, float = true })
      end, { desc = "Next diagnostic" })
      map("n", "<leader>ld", vim.diagnostic.open_float, { desc = "Line diagnostics" })
      map("n", "<leader>le", vim.diagnostic.setloclist, { desc = "Diagnostics in loclist" })
    end,
  },

  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
    opts = {
      -- `automatic_enable` (the default) calls vim.lsp.enable() for every
      -- server Mason has installed, so the server list lives in exactly one
      -- place: here.
      ensure_installed = {
        "lua_ls",
        "pyright",
        "bashls",
        "yamlls",
        "jsonls",
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    cmd = { "LspInfo", "LspLog" },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- nvim-lspconfig ships the per-server configs; we only add our settings
      -- on top. Neovim 0.11+ resolves these through vim.lsp.config().
      vim.lsp.config("*", {
        capabilities = capabilities,
      })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            workspace = { checkThirdParty = false },
            diagnostics = { globals = { "vim" } },
            telemetry = { enable = false },
          },
        },
      })
    end,
  },

  -- Completion -----------------------------------------------------------

  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      -- Pick up snippets from VS Code / LSP snippet directories.
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        -- Required as soon as the luasnip source is enabled.
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
        experimental = { ghost_text = true },
      })
    end,
  },

  -- Syntax highlighting and indentation ----------------------------------

  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    -- The `main` branch targets Neovim 0.12+. Highlighting and indentation are
    -- enabled per filetype in lua/autocmds.lua, since the rewrite dropped the
    -- `highlight`/`indent` setup options.
    config = function()
      require("nvim-treesitter").setup({
        install_dir = vim.fn.stdpath("data") .. "/site",
      })

      -- install() is a no-op for parsers that are already there, so this only
      -- does work on the first launch (and after adding a language). Add your
      -- own languages to this list.
      require("nvim-treesitter").install({
        "bash",
        "css",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      })
    end,
  },
}
