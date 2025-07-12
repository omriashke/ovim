-- deps:
require('cmp').setup ({
  -- use recommended settings from above
})
require('img-clip').setup ({
  -- use recommended settings from above
})
require('copilot').setup ({
  -- use recommended settings from above
})
require('render-markdown').setup ({
  -- use recommended settings from above
})
require('avante').setup({
  -- Example: Using snacks.nvim as input provider
  input = {
    provider = "snacks", -- "native" | "dressing" | "snacks"
    provider_opts = {
      -- Snacks input configuration
      title = "Avante Input",
      icon = " ",
      placeholder = "Enter your API key...",
    },
  },
  -- Your other config here!
})
