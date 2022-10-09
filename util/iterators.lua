local iterators = {}

function iterators.concat(i1, i2)
	return function()
		if i1 then
			local v = i1()
			if v then
				return v
			else
				i1 = nil
			end
		end
		return i2()
	end
end

function iterators.range(...)
	local a, b, c = ...
	if type(a) ~= "number" then
		error("invalid range")
	end
	if not b then
		a, b = 1, a
	end
	if type(b) ~= "number" then
		error("invalid range")
	end
	c = c or 1
	if type(c) ~= "number" or c == 0 then
		error("invalid range")
	end

	if c > 0 then
		return function()
			if a > b then
				return
			end
			local to_return = a
			a = a + c
			return to_return
		end

	else
		return function()
			if a < b then
				return
			end
			local to_return = a
			a = a + c
			return to_return
		end
	end
end

function iterators.n_of(n, o)
	local t = {}
	for _ = 1, n do
		table.insert(t, o)
	end
	return t
end

futil.iterators = iterators
