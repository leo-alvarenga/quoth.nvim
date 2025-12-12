# quoth.nvim

A robust, highly configurable, dependency-free random quote provider for Neovim, capable of lazy-loading quotes on demand and supports custom quote tables and filters.

Use it for:

- Startup notifications or dashboard messages
- Statusline / winbar quotes
- Contextual/tests messages content in your own plugins

## Features

- **Zero dependencies** (besides your own optional quote modules)
- **Lazy loading**: Quotes are only loaded when `get_random_quote()` or `get_random_quote_text()` is called
- **Custom quotes**: Provide your own `custom_quotes` table via `setup()`
- **Filtering**: Filter by author, tags, and length using a flexible `filter` option

## Installation

With **lazy.nvim**:

```lua
{
  "leo-alvarenga/quoth.nvim",
  opts = {},      -- All options are optional
  version = false,
  -- branch = "nightly", -- Uncomment to get the latest (possibly unstable) changes
}
```

## Usage

```lua
local quoth = require("quoth-nvim")

-- Simplest usage: get a quote object
local quote = quoth.get_random_quote()
vim.print(('%s — %s'):format(quote.text, quote.author))

-- Or get a pre-formatted string using your configured format
vim.print(quoth.get_random_quote_text())

-- Override the default filter just for this call
local stoic = quoth.get_random_quote({
  authors = { "aurelius", "seneca", "epictetus" },
  tags = { "stoic" },
  tag_mode = "and",
})

-- Both functions accept an optional `filter` parameter
-- which overrides the `filter` set via `setup()` for that call.
```

You can also get a random quote via the command:

```vim
:QuothGetRandom
```

The output of `:QuothGetRandom` and `get_random_quote_text()` is formatted according to `opts.format`.

## Lazy loading details

- Quotes are loaded **only** during `get_random_quote()` / `get_random_quote_text()` calls
- They are loaded into **local scope** (no global pollution)
- `custom_quotes` bypass file loading entirely

## Configuration

Example setup using all available options:

```lua
require("quoth-nvim").setup({
  ---@type quoth-nvim.Quote[]|nil
  custom_quotes = {
    {
      author = "Donald Knuth",
      text = "The real problem is not whether machines think but whether men do.",
      tags = { "thinking", "technology", "humanity" },
    },
    {
      author = "Linus Torvalds",
      text = "Talk is cheap. Show me the code.",
      tags = { "action", "execution", "results" },
    },
  },

  ---@type quoth-nvim.Filter|nil
  filter = {
    authors = { "seneca" },
    tags = { "stoic", "action", "progress" },
    tag_mode = "and",
    relax_author_search = true,
    length_constraints = {
      min = 40,
      max = 140,
    },
  },

  -- When true, quoth.nvim's built-in quotes are also considered alongside `custom_quotes`.
  -- If `custom_quotes` is nil, built-in quotes are used by default.
  include_all = true,

  random_int_fn = function(n)
    if n < 2 then
      return n
    end

    return n - 2
  end
})
```

### All options

| Field           | Type                              | Default                      | Description                                                                                                                                         |
| --------------- | --------------------------------- | ---------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| `custom_quotes` | `quoth-nvim.Quote[]` \| `nil`     | `nil`                        | Quotes you provide. If `nil`, only built-in quotes are used (depending on `include_all`).                                                           |
| `format`        | `string` \| `nil`                 | `'"{TEXT}" - {AUTHOR}'`      | Placeholder-based format used by `get_random_quote_text()` and `:QuothGetRandom`. Placeholders: `{TEXT}`, `{AUTHOR}`, `{COUNT}`.                    |
| `filter`        | `quoth-nvim.Filter` \| `nil`      | `nil`                        | Global filter applied before selecting a random quote. Can be overridden per-call via `get_random_quote(filter)` / `get_random_quote_text(filter)`. |
| `include_all`   | `boolean` \| `nil`                | `true` (if no custom quotes) | Whether built-in quotes should be included when filtering. If `custom_quotes` is `nil`, this is treated as `true`.                                  |
| `random_int_fn` | `fun(n: integer): integer`\|`nil` | `nil`                        | Function to be used when getting a random quote; Useful if you want more control over the selection behavior                                        |

#### Filter options

| Field                    | Type                                    | Default | Description                                                                                                                                       |
| ------------------------ | --------------------------------------- | ------- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| `authors`                | `string[]` \| `nil`                     | `nil`   | Only select quotes whose author matches one of these values. When `relax_author_search = true`, matching is case-insensitive and substring-based. |
| `tags`                   | `string[]` \| `nil`                     | `nil`   | Only select quotes that contain one or more of these tags (depending on `tag_mode`).                                                              |
| `tag_mode`               | `"and"` \| `"or"` \| `nil`              | `"or"`  | Tag matching mode. `"and"`: quote must contain **all** tags. `"or"`: quote must contain **at least one** tag.                                     |
| `length_constraints`     | `quoth-nvim.LengthConstraints` \| `nil` | `nil`   | Only select quotes that satisfy the length constraints.                                                                                           |
| `length_constraints.min` | `number` \| `nil`                       | `nil`   | Only select quotes whose text length is **greater than or equal** to this value (in characters).                                                  |
| `length_constraints.max` | `number` \| `nil`                       | `nil`   | Only select quotes whose text length is **less than or equal** to this value (in characters).                                                     |
| `relax_author_search`    | `boolean` \| `nil`                      | `false` | When `true`, author matching is case-insensitive and uses substring search. When `false`, author names must match exactly (case-sensitive).       |

## Types (for LuaLS / tooling)

These are the internal types used by quoth.nvim and are useful if you rely on LuaLS for completion and diagnostics:

```lua
---@class quoth-nvim.Quote
---@field author string  -- The person (or persona) credited with the quote
---@field text string    -- The quote text
---@field tags string[]  -- Tags related to the quote
---@field count integer  -- Number of quotes in the pool after all filters (0 means “no quotes found”)

---@class quoth-nvim.LengthConstraints
---@field min? integer
---@field max? integer

---@class quoth-nvim.Filter
---@field authors? string[]
---@field length_constraints? quoth-nvim.LengthConstraints
---@field random_int_fn (fun(n: integer): integer)|nil|?: A function to be used when getting a random quote
---@field relax_author_search? boolean
---@field tags? string[]
---@field tag_mode? "and"|"or"
```

## License

MIT – see [LICENSE](./LICENSE.md)
