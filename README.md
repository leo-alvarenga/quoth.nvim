# quoth.nvim

A dead simple random quote provider for Neovim. Lazy-loads quotes on demand and supports custom quote tables or filter by "kinds".

## Features

- **Zero dependencies** except optionally your own quote modules
- **Lazy loading**: Quotes loaded only when `get_random_quote()` is called, scoped to function
- **Custom quotes**: Pass your own `custom_quotes` table via `setup()`
- **Modular kinds**: Specify `kind = "stoic"` to load from `quotes/stoic.lua` (or any kind)
- **Tiny footprint**: ~50 LOC core, extensible via simple tables

## Installation

With **lazy.nvim**:

```lua
{
  "leo-alvarenga/quoth.nvim",
  opts = {
    -- Optional
    ---@type table<quoth-nvim.Quote>
    custom_quotes = {
        { author = "Seneca", text = "Luck is what happens when preparation meets opportunity." },
        { author = "Epictetus", text = "It’s not what happens to you, but how you react that matters." },
    },

    -- Optional (overwritten by custom_quotes)
    ---@type ?string|nil
    kind = "stoic",  -- loads quotes/stoic.lua
  },
}
```

## Usage

```lua
local quoth = require("quoth-nvim")
local random_quote = quoth.get_random_quote()

print(random_quote.text .. " - " .. random_quote.author)  -- :
```

**Key functions:**

- `get_random_quote(custom_quotes_or_kind)`: Returns random quote object
- `get_random_quote_text(custom_quotes_or_kind)`: Returns random quote as '"<Quote>" - Author'
  - Priority other is:
    - Call parameters
    - User opts
    - Default values

## Lazy Loading Details

- Quotes loaded **only** during `get_random_quote()` call
- Loaded into **local scope** (no global pollution)
- Custom quotes bypass file loading entirely

## Options

```lua
require("quoth-nvim").setup({
  custom_quotes = {},  -- A list-like table with items in the form of { author = "Some author", text = "Some quote" } (optional)
  kind = nil,          -- Default kind/module (optional)
})
```

Custom quotes take precedence over kinds. Perfect for startup messages, statusline quotes, or notifications.

## Roadmap

- [ ] Add more ways to extend and setup custom quotes
- [ ] Perfect the topic/kind filtering (maybe abstract it as an optional field in the Quote type?)

## License

MIT - see [LICENSE](./LICENSE.md)
