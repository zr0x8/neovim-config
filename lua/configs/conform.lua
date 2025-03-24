local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    cpp = { "clang-format" },
    c = { "clang-format" },
    rust = { "rustfmt", lsp_format = "fallback" },
  },

  format_on_save = {
    --   -- These options will be passed to conform.format()
    async = false,
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options
