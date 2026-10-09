-- Colorscheme and statusline. Replaces vim-solarized and vim-airline.

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = false,
        term_colors = true,
        -- `auto_integrations` (on by default) already detects cmp, lualine,
        -- nvim-tree and telescope from the loaded plugin set, so only the
        -- options that carry data need to be spelled out here.
        integrations = {
          native_lsp = { style = "symbol" },
        },
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        -- Must be the flavour-qualified name: catppuccin ships one lualine
        -- theme per flavour, there is no bare "catppuccin".
        theme = "catppuccin-mocha",
        -- globalstatus shows one statusline for all windows, the closest
        -- equivalent to the old `set laststatus=2`.
        globalstatus = true,
        icons_enabled = true,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = { statusline = { "NvimTree" } },
      },
    },
    config = function(_, opts)
      require("lualine").setup(opts)
    end,
  },
}