-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use {
    'nvim-telescope/telescope.nvim', tag = 'master',
    -- or                            , branch = '0.1.x',
    requires = { { 'nvim-lua/plenary.nvim' } }
  }
  use { "catppuccin/nvim", as = "catppuccin" }

  use {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    run = function()
      require('nvim-treesitter.install').update({ with_sync = true })
    end,
  }

  use { "nvim-treesitter/nvim-treesitter-context" }

  use {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    requires = { { "nvim-lua/plenary.nvim" } }
  }

  use { "neovim/nvim-lspconfig" }

  use { "mason-org/mason.nvim" }

  use({
    'saghen/blink.cmp',
    tag = 'v1.7.0', -- use an exact release tag with prebuilt binaries
    requires = { 'rafamadriz/friendly-snippets' },
    config = function()
      require('blink.cmp').setup({
        keymap = { preset = 'default' },

        appearance = {
          nerd_font_variant = 'mono',
        },

        completion = {
          documentation = { auto_show = true },
        },

        fuzzy = {
          -- Try Rust first, but silently revert to Lua if missing
          implementation = "prefer_rust",

          prebuilt_binaries = {
            download = true,
            force_version = 'v1.7.0', -- must match the tag above
          },
        },
      })
    end,
  })

  use { 'mfussenegger/nvim-dap' }

  use { 'theHamsta/nvim-dap-virtual-text' }

  use { 'WhoIsSethDaniel/mason-tool-installer.nvim' }

  use {
    "supermaven-inc/supermaven-nvim",
    config = function()
      require("supermaven-nvim").setup({})
    end,
  }

  use 'eandrju/cellular-automaton.nvim'

  use 'tidalcycles/vim-tidal'

  use({
    'MeanderingProgrammer/render-markdown.nvim',
    after = { 'nvim-treesitter' },
    requires = { 'nvim-mini/mini.nvim', opt = true },
    config = function()
      require('render-markdown').setup({})
    end,
  })
end)
