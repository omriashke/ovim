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
  use {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    requires = { { "nvim-lua/plenary.nvim" } }
  }

  use { "mbbill/undotree" }

  use { "tpope/vim-fugitive" }

  use { "neovim/nvim-lspconfig" }

  use { "mason-org/mason.nvim" }

  use({
    'saghen/blink.cmp',
    requires = { 'rafamadriz/friendly-snippets' }, -- optional snippets
    tag = 'v1.*',                                  -- use prebuilt binaries via tag
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
          implementation = "prefer_rust",
        },
      })
    end
  })
  use { "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } }
end)
