require 'nvim-treesitter'.setup {
  -- Directory to install parsers and queries to
  install_dir = vim.fn.stdpath('data') .. '/site'
}
require 'nvim-treesitter'.install { 'rust', 'javascript', 'typescript', 'cpp', 'html', 'css', 'python', 'c', 'lua', 'bash', 'JSON', 'hcl', 'markdown', 'markdown_inline', 'html', 'yaml', 'toml', 'json' }

require 'treesitter-context'.setup()
