require 'nvim-treesitter'.setup {
  -- Directory to install parsers and queries to
  install_dir = vim.fn.stdpath('data') .. '/site'
}
require 'nvim-treesitter'.install { 'rust', 'javascript', 'typescript', 'cpp', 'html', 'css', 'python', 'c', 'lua', 'bash' }

require 'treesitter-context'.setup()
