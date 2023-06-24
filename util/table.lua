local floor = math.floor
local min = math.min
local default_cmp = futil.math.cmp

futil.table = {}

function futil.table.set_all(t1, t2)
	for k, v in pairs(t2) do
		t1[k] = v
	end
	return t1
end

function futil.table.pairs_by_value(t, cmp)
	cmp = cmp or default_cmp
	local s = {}
	for k, v in pairs(t) do
		table.insert(s, { k, v })
	end

	table.sort(s, function(a, b)
		return cmp(a[2], b[2])
	end)

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

function futil.table.pairs_by_key(t, cmp)
	cmp = cmp or default_cmp
	local s = {}
	for k, v in pairs(t) do
		table.insert(s, { k, v })
	end

	table.sort(s, function(a, b)
		return cmp(a[1], b[1])
	end)

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

function futil.table.keys(t)
	local keys = {}
	for key in pairs(t) do
		keys[#keys + 1] = key
	end
	return keys
end

function futil.table.values(t)
	local values = {}
	for _, value in pairs(t) do
		values[#values + 1] = value
	end
	return values
end

function futil.table.sort_keys(t, cmp)
	local keys = futil.table.keys(t)
	table.sort(keys, cmp)
	return keys
end

-- https://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle
function futil.table.shuffle(t, rnd)
	rnd = rnd or math.random
	for i = #t, 2, -1 do
		local j = rnd(i)
		t[i], t[j] = t[j], t[i]
	end
	return t
end

local function swap(t, i, j)
	t[i], t[j] = t[j], t[i]
end

futil.table.swap = swap

local function partition5(t, left, right, cmp)
	cmp = cmp or default_cmp
	local i = left + 1
	while i <= right do
		local j = i
		while j > left and cmp(t[j], t[j - 1]) do
			swap(t, j - 1, j)
			j = j - 1
		end
		i = i + 1
	end
	return floor((left + right) / 2)
end

local select
local partition
local function pivot(t, left, right, cmp)
	cmp = cmp or default_cmp
	if right - left < 5 then
		return partition5(t, left, right, cmp)
	end
	for i = left, right, 5 do
		local sub_right = min(i + 4, right)
		local median5 = partition5(t, i, sub_right, cmp)
		swap(t, median5, left + floor((i - left) / 5))
	end
	local mid = floor((right - left) / 10) + left + 1
	return select(t, left, left + floor((right - left) / 5), mid, cmp)
end

function select(t, left, right, i, cmp)
	cmp = cmp or default_cmp
	while true do
		if left == right then
			return left
		end
		local pivot_i = partition(t, left, right, pivot(t, left, right, cmp), i, cmp)
		if i == pivot_i then
			return i
		elseif i < pivot_i then
			right = pivot_i - 1
		else
			left = pivot_i + 1
		end
	end
end

function partition(t, left, right, pivot_i, i, cmp)
	cmp = cmp or default_cmp
	local pivot_v = t[pivot_i]
	assert(pivot_v, pivot_i)
	swap(t, pivot_i, right)
	local store_i = left
	for j = left, right - 1 do
		assert(t[j])
		if cmp(t[j], pivot_v) then
			swap(t, store_i, j)
			store_i = store_i + 1
		end
	end
	local store_i_eq = store_i
	for j = store_i, right - 1 do
		if t[j] == pivot_v then
			swap(t, store_i_eq, j)
			store_i_eq = store_i_eq + 1
		end
	end
	swap(t, right, store_i_eq)
	if i < store_i then
		return store_i
	elseif i <= store_i_eq then
		return i
	else
		return store_i_eq
	end
end

--[[
make use of quickselect to munge a table:
	median_index = math.floor(#t / 2)
	after calling this,
	t[1] through t[median_index - 1] will be the elements less than t[median_index]
	t[median_index] will be the median (or element less-than-the-median for even length tables)
	t[median_index + 1] through t[#t] will be the elements greater than t[median_index]
returns median_index.
runs in O(n) time
]]
function futil.table.medianize(t, cmp)
	cmp = cmp or default_cmp
	local median_index = math.floor(#t / 2)
	return select(t, 1, #t, median_index, cmp)
end
