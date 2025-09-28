-- Note: The standard nvim-treesitter.configs setup doesn't work with this version
-- Using manual treesitter highlighting setup instead

-- Enable treesitter highlighting for specific filetypes
local function enable_treesitter_for_filetype(filetype, parser_name)
  vim.api.nvim_create_autocmd('FileType', {
    pattern = filetype,
    callback = function(args)
      local buf = args.buf
      -- Check if parser exists
      local parser_path = vim.fn.stdpath('data') .. '/site/parser/' .. parser_name .. '.so'
      if vim.fn.filereadable(parser_path) == 1 then
        -- Enable treesitter highlighting for this buffer
        pcall(function()
          vim.treesitter.start(buf, parser_name)
        end)
      end
    end,
  })
end

-- Enable treesitter for common filetypes
enable_treesitter_for_filetype('markdown', 'markdown')
enable_treesitter_for_filetype('lua', 'lua')
enable_treesitter_for_filetype('python', 'python')
enable_treesitter_for_filetype('javascript', 'javascript')
enable_treesitter_for_filetype('typescript', 'typescript')
enable_treesitter_for_filetype('json', 'json')
enable_treesitter_for_filetype('yaml', 'yaml')
enable_treesitter_for_filetype('toml', 'toml')
enable_treesitter_for_filetype('rust', 'rust')
enable_treesitter_for_filetype('c', 'c')
enable_treesitter_for_filetype('cpp', 'cpp')
enable_treesitter_for_filetype('css', 'css')
enable_treesitter_for_filetype('html', 'html')
enable_treesitter_for_filetype('bash', 'bash')
enable_treesitter_for_filetype('vim', 'vim')
