---Fallback function to get a random int
---@param len number
local function get_randint_with_user_fn(len)
	local random_int_fn = require("quoth-nvim.config").options.random_int_fn

	if type(random_int_fn) ~= "function" then
		return nil
	end

	local num = math.abs(random_int_fn(len))

	if type(num) ~= "number" or (num < 1 or num > len) then
		return -1
	end

	return num
end

---Given a limit of N, generate a random (or pseudo-random) integer from 1 to N (inclusive)
---@param len number
local function get_random_index(len)
	local num = get_randint_with_user_fn(len)

	if num ~= nil then
		if num > 0 and num <= len then
			return num
		end

		vim.notify(
			"[quoth.nvim] Falling back to math.random as user defined random_int_fn did not yield a valid value",
			vim.log.levels.ERROR
		)
	end

	math.randomseed(os.time())
	return math.random(len)
end

return get_random_index
