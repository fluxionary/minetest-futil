
function futil.table_set_all(t1, t2)
	for k,v in pairs(t2) do
		t1[k] = v
	end
	return t1
end

function futil.pairs_by_value(t, sort_function)
	local s = {}
	for k, v in pairs(t) do
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

function futil.pairs_by_key(t, sort_function)
	local s = {}
	for k, v in pairs(t) do
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

local function table_size(t)
	local size = 0
	for _ in pairs(t) do
		size = size + 1
	end
	return size
end

futil.table_size = table_size

function futil.table_is_empty(t)
	return next(t) == nil
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

function futil.count_elements(t)
	local counts = {}
	if t then
		for _, item in ipairs(t) do
			counts[item] = (counts[item] or 0) + 1
		end
	end
	return counts
end

function futil.sets_intersect(set1, set2)
	for k in pairs(set1) do
		if set2[k] then
			return true
		end
	end

	return false
end
