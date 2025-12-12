local M = {}

M.placeholders = {
	author = "{AUTHOR}",
	count = "{COUNT}",
	text = "{TEXT}",
}

M.fallback_format = '"' .. M.placeholders.text .. '"' .. " - " .. M.placeholders.author

---@type quoth-nvim.Quote
M.empty_quote = {
	author = "quoth.nvim, Error",
	count = 0,
	tags = { "empty" },
	text = "This is a fallback quote. If you are seeing this, it probably means that your filter options are too specific and no matching quotes could be found to satisfy it",
}

return M
