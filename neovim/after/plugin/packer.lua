local first_run_file = vim.fn.stdpath("data") .. "/packer_first_run"

if vim.fn.filereadable(first_run_file) == 0 then
    vim.notify("First run detected - syncing plugins with Packer...")
    
    vim.cmd("PackerSync")
    
    -- Create marker file to prevent future runs
    vim.fn.writefile({"First run completed"}, first_run_file)
end
