---Prefix with the plugin prefix for safe module require
---@param arg string
---@return string
local function prefix(arg)
	if not arg or type(arg) ~= "string" then
		return ""
	end

	return "quoth-nvim.quotes." .. arg
end

local files = {
	"stoic",
	"tech",
}

---Get all quotes
---@return table
local function get_all()
	local quotes = {}

	local opts = require("quoth-nvim.config").options
	-- Include all native quotes if true or if no custom_quotes were provided
	if not opts.custom_quotes or opts.include_all then
		for _, file in ipairs(files) do
			local t_quotes = require(prefix(file))

			if type(t_quotes) == "table" then
				quotes = vim.tbl_extend("force", quotes, t_quotes)
			end
		end
	end

	if type(opts.custom_quotes) == "table" then
		quotes = vim.tbl_extend("force", quotes, opts.custom_quotes or {})
	end

	return quotes
end

return get_all
