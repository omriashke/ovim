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
    requires = { 'rafamadriz/friendly-snippets', 'Kaiser-Yang/blink-cmp-avante' }, -- optional snippets
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
          implementation = "prefer_rust_with_warning",
        },
        sources = {
          default = { 'avante', 'lsp', 'path', 'snippets', 'buffer' },
          providers = {
            avante = {
              module = 'blink-cmp-avante',
              name = 'Avante',
            },
          }
        }
      })
    end
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

  -- Required plugins
  use 'MunifTanjim/nui.nvim'
  use 'MeanderingProgrammer/render-markdown.nvim'

  -- Optional dependencies
  use 'hrsh7th/nvim-cmp'
  use 'echasnovski/mini.icons'
  use 'HakonHarnes/img-clip.nvim'
  use 'zbirenbaum/copilot.lua'
  use 'stevearc/dressing.nvim' -- for enhanced input UI
  use 'folke/snacks.nvim'      -- for modern input UI

  -- Avante.nvim with build process
  use {
    'yetone/avante.nvim',
    branch = 'main',
    run = "make",
    config = function()
      require('avante').setup()
    end
  }

  use 'eandrju/cellular-automaton.nvim'

  use 'tidalcycles/vim-tidal'
end)
