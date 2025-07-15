local dap = require("dap")

require("nvim-dap-virtual-text").setup()

vim.keymap.set("n", "<space>b", dap.toggle_breakpoint)
vim.keymap.set("n", "<space>gb", dap.run_to_cursor)
vim.keymap.set('n', '<leader>hb', function()
  require('dap.ui.widgets').hover()
end)

-- Eval var under cursor
vim.keymap.set("n", "<space>?", function()
  require("dapui").eval(nil, { enter = true })
end)

vim.keymap.set("n", "<F1>", dap.continue)
vim.keymap.set("n", "<F2>", dap.step_into)
vim.keymap.set("n", "<F3>", dap.step_over)
vim.keymap.set("n", "<F4>", dap.step_out)
vim.keymap.set("n", "<F5>", dap.step_back)

dap.adapters["pwa-node"] = {
  type = "server",
  host = "localhost",
  port = "${port}",
  executable = {
    command = '/root/.local/share/nvim/mason/bin/js-debug-adapter',
    args = { "${port}" },
  }
}
dap.configurations.typescript = {
  {
    type = "pwa-node",
    request = "attach",
    name = "Attach",
    processId = require('dap.utils').pick_process,
    cwd = "${workspaceFolder}",
    sourceMaps = true,
  },
}
