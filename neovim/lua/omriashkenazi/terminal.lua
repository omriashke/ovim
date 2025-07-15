vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.opt_local.number = true
    vim.opt_local.relativenumber = true
    vim.opt_local.laststatus = 0 -- Hide status line
  end,
})

vim.api.nvim_create_autocmd("ModeChanged", {
  pattern = { "*:t", "t:*" },
  callback = function()
    if vim.bo.buftype == "terminal" then
      if vim.fn.mode() == "t" then
        -- Entering terminal mode
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
      else
        -- Leaving terminal mode
        vim.opt_local.number = true
        vim.opt_local.relativenumber = true
      end
    end
  end,
})

-- Restore status line when leaving terminal buffer
vim.api.nvim_create_autocmd("BufLeave", {
  pattern = "term://*",
  callback = function()
    vim.opt.laststatus = 2 -- Restore status line
  end,
})

-- Hide status line when entering terminal buffer
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "term://*",
  callback = function()
    vim.opt.laststatus = 0 -- Hide status line
  end,
})
