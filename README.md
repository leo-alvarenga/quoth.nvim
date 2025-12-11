# quoth.nvim

A dead simple, dependency-free random quote provider for Neovim. Lazy-loads quotes on demand and supports custom quote tables and/or filtering by tags.

## Features

- **Zero dependencies** except optionally your own quote modules
- **Lazy loading**: Quotes loaded only when `get_random_quote()` is called
- **Custom quotes**: Pass your own `custom_quotes` table via `setup()`
- **Filter quotes**: Narrow down the quote pool from which quotes are picked by adding `filter` values via `setup()` or as parameters when calling via the API

## Installation

With **lazy.nvim**:

```lua
{
    "leo-alvarenga/quoth.nvim",
    opts = {
        -- Optional
        ---@type table<quoth-nvim.Quote>
        custom_quotes = {
            {
                author = "Donald Knuth",
                text = "The real problem is not whether machines think but whether men do",
                tags = { "stoic", "thinking", "technology", "humanity" },
            },
            {
                author = "Linus Torvalds",
                text = "Talk is cheap. Show me the code",
                tags = { "action", "execution", "results" },
            },
        },

        -- Optional
        ---@type quoth-nvim.Filter|?
        filter = {
            tags = { "stoic", "action", "progress" }, -- If left empty, missing or nil all quotes are added to the quote pool
            mode = "and", -- "and" means that a quote is only a match if it contains ALL tags
                              -- passed in the filter
        },

        -- Optional
        include_all = false, -- If true, quotes packaged with quoth.nvim will also be considering
                                -- during the filtering
    },
    version = false,
    -- branch = "nightly" -- Use this to get the latest (possibly unstable) changes
}
```

## Usage

```lua
local quoth = require("quoth-nvim")
local random_quote = quoth.get_random_quote() -- You could also use the `get_random_quote_text` to get the quote in the exact format as seen below

vim.print(random_quote.text .. " - " .. random_quote.author)
```

**Key functions:**

- `get_random_quote(filter)`: Returns random quote object
- `get_random_quote_text(filter)`: Returns random quote as '"<Quote>" - Author'

> In both usages, `filter` is optional and overrides the `filter` set via `opts` if present

## Lazy Loading Details

- Quotes loaded **only** during `get_random_quote()` or `get_random_quote_text()` calls
- Loaded into **local scope** (no global pollution)
- Custom quotes bypass file loading entirely

## Options

```lua
require("quoth-nvim").setup({
        -- Optional
        ---@type table<quoth-nvim.Quote>
        custom_quotes = {
            {
                author = "Donald Knuth",
                text = "The real problem is not whether machines think but whether men do",
                tags = { "stoic", "thinking", "technology", "humanity" },
            },
            {
                author = "Linus Torvalds",
                text = "Talk is cheap. Show me the code",
                tags = { "action", "execution", "results" },
            },
        },

        ---@type quoth-nvim.Filter|?
        filter = {
            tags = { "stoic", "action", "progress" },
            mode = "and", -- "and" means that a quote is only a match if it contains ALL tags
                              -- passed in the filter
        },

        include_all = false, -- If true, quotes packaged with the quoth.nvim will also be considering
                                -- during the filtering
    })
```

## License

MIT - see [LICENSE](./LICENSE.md)
