require("mason").setup()

local registry = require("mason-registry")

local function ensure_installed(tool)
  if not registry.is_installed(tool) then
    local ok, pkg = pcall(registry.get_package, tool)
    if ok and not pkg:is_installed() then
      pkg:install()
    end
  end
end

local tools = {
  -- LSP
  "lua-language-server",
  "typescript-language-server",
  -- DAP
  "js-debug-adapter"
}

for _, tool in ipairs(tools) do
  ensure_installed(tool)
end
