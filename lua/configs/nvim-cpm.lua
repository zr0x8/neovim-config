local cmp = require "cmp"

local has_words_before = function()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
end

local settings = {}

settings.mapping = {  
  -- Up and Down arrow keys for selecting completion items
  ["<Up>"] = cmp.mapping.select_prev_item(),
	["<Down>"] = cmp.mapping.select_next_item(),

  ["<C-Down>"] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_next_item()
    elseif require("luasnip").expand_or_jumpable() then
      require("luasnip").expand_or_jump()
    else
      fallback()
    end
  end, { "i", "s" }),

  ["<C-Up>"] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_prev_item()
    elseif require("luasnip").jumpable(-1) then
      require("luasnip").jump(-1)
    else
      fallback()
    end
  end, { "i", "s" }),

  ["<Tab>"] = vim.schedule_wrap(function(fallback)
    if cmp.visible() and has_words_before() then
      cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
    else
      fallback()
    end
  end),

  -- Ctrl+Tab for Copilot completions
  ["<C-Tab>"] = cmp.mapping(function(fallback)
    local copilot_suggestion = require "copilot.suggestion"
    if copilot_suggestion.is_visible() then
      copilot_suggestion.accept()
    else
      fallback()
    end
  end, { "i", "s" }),

  -- Optional: Add PageUp and PageDown for scrolling through completion docs
  ["<PageDown>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
  ["<PageUp>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
}

settings.sorting = {
  priority_weight = 2,
  comparators = {
    require("copilot_cmp.comparators").prioritize,

    -- Below is the default comparitor list and order for nvim-cmp
    cmp.config.compare.offset,
    -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
    cmp.config.compare.exact,
    cmp.config.compare.score,
    cmp.config.compare.recently_used,
    cmp.config.compare.locality,
    cmp.config.compare.kind,
    cmp.config.compare.sort_text,
    cmp.config.compare.length,
    cmp.config.compare.order,
  },
}

return settings
