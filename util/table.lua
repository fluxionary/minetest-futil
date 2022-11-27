futil.table = {}

function futil.table.set_all(t1, t2)
	for k, v in pairs(t2) do
		t1[k] = v
	end
end

function futil.table.pairs_by_value(t, sort_function)
	local s = {}
	for k, v in pairs(t) do
		table.insert(s, { k, v })
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

function futil.table.pairs_by_key(t, sort_function)
	local s = {}
	for k, v in pairs(t) do
		table.insert(s, { k, v })
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

function futil.table.size(t)
	local size = 0
	for _ in pairs(t) do
		size = size + 1
	end
	return size
end

function futil.table.is_empty(t)
	return next(t) == nil
end

function futil.table.count_elements(t)
	local counts = {}
	for _, item in ipairs(t) do
		counts[item] = (counts[item] or 0) + 1
	end
	return counts
end

function futil.table.sets_intersect(set1, set2)
	for k in pairs(set1) do
		if set2[k] then
			return true
		end
	end

	return false
end

function futil.table.iterate(t)
	local i = 0
	return function()
		i = i + 1
		return t[i]
	end
end

function futil.table.reversed(t)
	local len = #t
	local reversed = {}

	for i = len, 1, -1 do
		reversed[len - i + 1] = t[i]
	end

	return reversed
end

function futil.table.contains(t, value)
	for _, v in ipairs(t) do
		if v == value then
			return true
		end
	end

	return false
end
