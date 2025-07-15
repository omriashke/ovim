require("mason").setup()

require("mason-tool-installer").setup({
  ensure_installed = {
    "rust-analyzer",
    "lua-language-server",
    "typescript-language-server",
    "js-debug-adapter",
    "prisma-language-server",
  },
})
