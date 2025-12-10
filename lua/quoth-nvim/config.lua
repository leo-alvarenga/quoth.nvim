local M = {}

---@class quoth-nvim.Quote
---@field author string: The person (or persona) credited to the quote
---@field text string: The quote as a literal string

---@class quoth-nvim.Options
---@field custom_quotes table<quoth-nvim.Quote>|nil|?: A flat table containing all custom quotes; It WILL take priority over the `kind` option
---@field kind string|nil|?: A valid kind* to be used as a filter when populating the pool from which a quote is picked from; *) A valid kind is module under quoth-nvim.quotes

---@type quoth-nvim.Options
M.defaults = {
	custom_quotes = nil,
	kind = nil,
}

---@type quoth-nvim.Options
M.options = {
	custom_quotes = M.defaults.custom_quotes,
	kind = M.defaults.kind,
}

---Sets up options (if present)
---@param opts ?quoth-nvim.Options
function M.set_options(opts)
	if not opts then
		return
	end

	M.options = vim.tbl_deep_extend("force", M.defaults, opts or M.options)
end

return M
