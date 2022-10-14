-- luacheck: globals table

function table:set_all(t2)
	for k,v in pairs(t2) do
		self[k] = v
	end
end

function table:pairs_by_value(sort_function)
	local s = {}
	for k, v in pairs(self) do
		table.insert(s, {k, v})
	end

	if sort_function then
		table.sort(s, function(a, b)
			return sort_function(a[2], b[2])
		end)
	else
		table.sort(s, function(a, b)
			return a[2] < b[2]
		end)
	end

	local i = 0
	return function()
		i = i + 1
		local v = s[i]
		if v then
			return unpack(v)
		else
			return nil
		end
	end
end

function table:pairs_by_key(sort_function)
	local s = {}
	for k, v in pairs(self) do
		table.insert(s, {k, v})
	end

	if sort_function then
		table.sort(s, function(a, b)
			return sort_function(a[1], b[1])
		end)
	else
		table.sort(s, function(a, b)
			return a[1] < b[1]
		end)
	end

	local i = 0
	return function()
		i = i + 1
		local v = s[i]
		if v then
			return unpack(v)
		else
			return nil
		end
	end
end

function table:size()
	local size = 0
	for _ in pairs(self) do
		size = size + 1
	end
	return size
end

local table_size = table.size

function table:is_empty()
	return next(self) == nil
end

local function equals(a, b)
	local t = type(a)

	if t ~= type(b) then
		return false
	end

	if t ~= "table" then
		return a == b

	elseif a == b then
		return true
	end

	local size_a = 0

	for key, value in pairs(a) do
		if not equals(value, b[key]) then
			return false
		end
		size_a = size_a + 1
	end

	return size_a == table_size(b)
end

futil.equals = equals

function table:count_elements()
	local counts = {}
	for _, item in ipairs(self) do
		counts[item] = (counts[item] or 0) + 1
	end
	return counts
end

function table:sets_intersect(set2)
	for k in pairs(self) do
		if set2[k] then
			return true
		end
	end

	return false
end

function futil.list(iterator)
	local t = {}
	local v = iterator()
	while v do
		table.insert(t, v)
		v = iterator()
	end
	return t
end

function futil.list_multiple(iterator)
	local t = {}
	local v = {iterator()}
	while #v do
		table.insert(t, v)
		v = {iterator()}
	end
	return t
end

function table:iterate()
	local i = 0
	return function()
		i = i + 1
		return self[i]
	end
end