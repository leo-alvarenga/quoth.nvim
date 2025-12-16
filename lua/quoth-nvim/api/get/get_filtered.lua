local function dummy_function(obj)
	return type(obj) == "table"
end

---Returns a safe to use tag matcher function
---@param length_constraints quoth-nvim.LengthConstraints|nil|?: LengthConstraints filter
---@return function(quote_obj) -> boolean: Safe to use matcher function
local function get_length_matcher(length_constraints)
	if
		type(length_constraints) ~= "table"
		or (type(length_constraints.max) ~= "number" and type(length_constraints.min) ~= "number")
	then
		return dummy_function
	end

	return function(quote_obj)
		if type(quote_obj) ~= "table" then
			return false
		end

		local is_long_enough = not length_constraints.min or string.len(quote_obj.text) >= length_constraints.min
		local is_short_enough = not length_constraints.max or string.len(quote_obj.text) <= length_constraints.max

		return is_long_enough and is_short_enough
	end
end

---Returns a safe to use tag matcher function
---@param filter quoth-nvim.Filter|nil|?: Filter options
---@return function(quote_obj) -> boolean: Safe to use matcher function
local function get_tag_matcher(filter)
	local tags = filter and filter.tags
	local tag_mode = (filter and filter.tag_mode) or "or"

	if type(tags) ~= "table" or next(tags) == nil then
		return dummy_function
	end

	return function(quote_obj)
		if type(quote_obj) ~= "table" then
			return false
		end

		local iter = vim.iter(tags)

		if tag_mode == "and" then
			return iter:all(function(t)
				return string.len(t) == 0 or vim.iter(quote_obj.tags):any(function(tag)
					return t == tag
				end)
			end)
		end

		return iter:any(function(t)
			return string.len(t) == 0 or vim.iter(quote_obj.tags):any(function(tag)
				return t == tag
			end)
		end)
	end
end

---Returns wheter or not the quote_obj has a matching author to the filter; Assumes all params are valid and non-nil
---@param quote_obj quoth-nvim.Quote
---@param authors string[]
---@param relax_author_search boolean?
---@return boolean
local function has_matching_author(quote_obj, authors, relax_author_search)
	if type(authors) ~= "table" or next(authors) == nil then
		return true
	end

	if not relax_author_search then
		return vim.iter(authors):any(function(author)
			return string.len(author) > 0 and quote_obj.author == author
		end)
	end

	return vim.iter(authors):any(function(author)
		if type(author) ~= "string" or string.len(author) == 0 then
			return true
		end

		local author_parts = vim.iter(vim.split(author, " ", { plain = true, trimempty = true }))
			:map(function(part)
				return string.lower(part)
			end)
			:totable()

		return vim.iter(author_parts):any(function(part)
			if string.find(string.lower(quote_obj.author), part, 1, true) then
				return true
			end

			return false
		end)
	end)
end

---Returns a safe to use author matcher function
---@param authors string[]|nil|?
---@param relax_author_search boolean?
---@return function(quote_obj) -> boolean: Safe to use function to determine whether or not a quote has an author matching the filters
local function get_author_matcher(authors, relax_author_search)
	if type(authors) ~= "table" or next(authors) == nil then
		return function(quote_obj)
			return type(quote_obj) == "table"
		end
	end

	return function(quote_obj)
		return has_matching_author(quote_obj, authors, relax_author_search)
	end
end

---Get all tags containing `tag`
---@param filter ?quoth-nvim.Filter
local function get_filtered(filter)
	local config = require("quoth-nvim.config").options or {}

	local get_all = require("quoth-nvim.api.get.get_all")
	local all_quotes = get_all()

	if type(filter) ~= "table" and type(config.filter) ~= "table" then
		return all_quotes
	end

	---@type quoth-nvim.Filter
	local safe_filter = vim.tbl_deep_extend("force", {}, config.filter or {}, filter or {})

	local is_within_length_constraints = get_length_matcher(safe_filter and safe_filter.length_constraints)
	local has_author =
		get_author_matcher(safe_filter and safe_filter.authors, safe_filter and safe_filter.relax_author_search)
	local has_matching_tags = get_tag_matcher(safe_filter)

	return vim.iter(all_quotes)
		:filter(function(quote_obj)
			if type(quote_obj) ~= "table" or type(quote_obj.tags) ~= "table" then
				return false
			end

			return is_within_length_constraints(quote_obj) and has_author(quote_obj) and has_matching_tags(quote_obj)
		end)
		:totable()
end

return get_filtered
