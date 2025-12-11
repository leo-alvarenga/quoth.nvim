local M = {}

---@class quoth-nvim.Filter
---@field tags table<string>|nil|?: A table with tags to look for when determining the quote pool
---@field mode "and"|"or"|?: The criteria to be applied when matching tags (default: or)

---@class quoth-nvim.Quote
---@field author string: The person (or persona) credited to the quote
---@field text string: The quote as a literal string

---@class quoth-nvim.Options
---@field custom_quotes table<quoth-nvim.Quote>|nil|?: A flat table containing all custom quotes
---@field filter quoth-nvim.Filter|?: A table containing the filter to be applied when determining the quote pool
---@field include_all boolean|nil|?: Whether or not to include pre-packaged quotes in the quote pool when selecting a random one

---@type quoth-nvim.Options
M.defaults = {
	include_all = true,
}

---@type quoth-nvim.Options
M.options = {
	include_all = M.defaults.include_all,
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
