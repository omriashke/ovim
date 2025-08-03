vim.cmd.colorscheme "catppuccin"

vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1e1e2e", fg = "#cdd6f4" }) -- floating window content
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "#1e1e2e", fg = "#89b4fa" }) -- border
vim.api.nvim_set_hl(0, "Pmenu", { bg = "#1e1e2e", fg = "#cdd6f4" })       -- completion menu
vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#89b4fa", fg = "#1e1e2e" })    -- selected completion
