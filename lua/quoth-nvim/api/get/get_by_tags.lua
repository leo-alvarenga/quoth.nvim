---Get all tags containing `tag`
---@param filter ?quoth-nvim.Filter
local function get_by_tags(filter)
	local get_all = require("quoth-nvim.api.get.get_all")
	local all_quotes = get_all()

	local safe_filter = vim.tbl_deep_extend("force", require("quoth-nvim.config").options.filter or {}, filter or {})

	if type(safe_filter.tags) ~= "table" then
		return all_quotes
	end

	local quotes = vim.iter(all_quotes):filter(function(quote_obj)
		if not quote_obj or type(quote_obj) ~= "table" or type(quote_obj.tags) ~= "table" then
			return false
		end

		if safe_filter.mode == "and" then
			return vim.iter(safe_filter.tags):all(function(t)
				return vim.iter(quote_obj.tags):any(function(tag)
					return t == tag
				end)
			end)
		end

		return vim.iter(safe_filter.tags):any(function(t)
			return vim.iter(quote_obj.tags):any(function(tag)
				return t == tag
			end)
		end)
	end)

	return quotes:totable()
end

return get_by_tags
