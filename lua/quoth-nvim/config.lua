local M = {}

---@class quoth-nvim.LengthConstraints
---@field max number|?: Only select from quotes that have a length <= max
---@field min number|?: Only select from quotes that have a length >= min

---@class quoth-nvim.Filter
---@field authors table<string>|nil|?: A table with authors to look for when determining the quote pool
---@field tags table<string>|nil|?: A table with tags to look for when determining the quote pool
---@field length_constraints quoth-nvim.LengthConstraints|nil|?: Constraints to abide by when filtering the quote pool
---@field tag_mode "and"|"or"|?: The criteria to be applied when matching tags and authors (default: or)
---@field relax_author_search boolean|nil|?: If false, author names must be exact (case sensitive) matches

---@class quoth-nvim.Quote
---@field author string: The person (or persona) credited to the quote
---@field count number|?: Quote pool size after all filters are applied; When 0, no quotes were found, and the quote is an error message in disguise
---@field tags table<string>: A list-like table with all tags related to the quote
---@field text string: The quote as a literal string

---@class quoth-nvim.Options
---@field custom_quotes table<quoth-nvim.Quote>|nil|?: A flat table containing all custom quotes
---@field filter quoth-nvim.Filter|?: A table containing the filter to be applied when determining the quote pool
---@field format string|?: A string with placeholders ({AUTHOR}, {COUNT}, {TEXT}) to be replaced with the quote contents when returning it as a string
---@field include_all boolean|nil|?: Whether or not to include pre-packaged quotes in the quote pool when selecting a random one

---@type quoth-nvim.Options
M.defaults = {
	filter = nil,
	format = require("quoth-nvim.api.utils").fallback_format,
	include_all = true,
}

---@type quoth-nvim.Options
M.options = vim.tbl_deep_extend("force", {}, M.defaults)

---Sets up options (if present)
---@param opts ?quoth-nvim.Options
function M.set_options(opts)
	if not opts then
		return
	end

	M.options = vim.tbl_deep_extend("force", M.defaults, opts or M.options)
end

return M
