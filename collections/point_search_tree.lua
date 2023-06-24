--[[
a data structure which can efficiently retrieve values within specific regions of 3d space.

the hope here is that this will provide a faster alternative to `minetest.get_objects_in_area()`, which iterates
over *all* active objects in the world, which can be slow when there's thousands of objects in the world.

the current implementation is static - all data points are provided up front.

https://en.wikipedia.org/wiki/Min/max_kd-tree
https://medium.com/omarelgabrys-blog/geometric-applications-of-bsts-e58f0a5019f3
]]
local in_area = vector.in_area
	or function(pos, pmin, pmax)
		return pmin.x <= pos.x
			and pos.x <= pmax.x
			and pmin.y <= pos.y
			and pos.y <= pmax.y
			and pmin.z <= pos.z
			and pos.z <= pmax.z
	end

local axes = { "x", "y", "z" }
local POS = 1
local VALUE = 2

local Leaf = futil.class1()

function Leaf:_init(pos_and_value)
	self[POS] = pos_and_value[POS]
	self[VALUE] = pos_and_value[VALUE]
end

local Node = futil.class1()

function Node:_init(min, max, left, right)
	self.min = min
	self.max = max
	self.left = left
	self.right = right
end

local PointSearchTree = futil.class1()

local function bisect(pos_and_values, axis_i)
	if #pos_and_values == 1 then
		return Leaf(pos_and_values[1])
	end

	local axis = axes[axis_i]

	local median = futil.table.medianize(pos_and_values, function(a, b)
		return a[POS][axis] < b[POS][axis]
	end)
	local min = pos_and_values[1][POS][axis]
	local max = min
	for i = 2, #pos_and_values do
		local v = pos_and_values[i][POS][axis]
		if v < min then
			min = v
		elseif v > max then
			max = v
		end
	end

	local next_axis_i = (axis_i % #axes) + 1
	return Node(
		min,
		max,
		bisect({ unpack(pos_and_values, 1, median) }, next_axis_i),
		bisect({ unpack(pos_and_values, median + 1) }, next_axis_i)
	)
end

function PointSearchTree:_init(pos_and_values)
	self._len = #pos_and_values
	if #pos_and_values > 0 then
		self._root = bisect(pos_and_values, 1)
	end
end

-- -DLUAJIT_ENABLE_LUA52COMPAT
function PointSearchTree:__len()
	return self._len
end

function PointSearchTree:dump()
	local function getlines(node, axis_i)
		local axis = axes[axis_i]
		if not node then
			return {}
		elseif node:is_a(Leaf) then
			return { minetest.pos_to_string(node[POS], 1) }
		else
			local lines = {}
			for _, line in ipairs(getlines(node.left, (axis_i % #axes) + 1)) do
				lines[#lines + 1] = string.format("%s=[%.1f,%.1f] %s", axis, node.min, node.max, line)
			end
			for _, line in ipairs(getlines(node.right, (axis_i % #axes) + 1)) do
				lines[#lines + 1] = string.format("%s=[%.1f,%.1f] %s", axis, node.min, node.max, line)
			end
			return lines
		end
	end

	return table.concat(getlines(self._root, 1), "\n")
end

local function make_iterator(pmin, pmax, predicate, accumulate)
	local function iterate(node, axis_i)
		local next_axis_i = (axis_i % 3) + 1
		local next_axis = axes[next_axis_i]

		local left = node.left
		if left then
			if left:is_a(Leaf) then
				if predicate(left) then
					accumulate(left)
				end
			elseif pmin[next_axis] <= left.max then
				iterate(left, next_axis_i)
			end
		end

		local right = node.right
		if right then
			if right:is_a(Leaf) then
				if predicate(right) then
					accumulate(right)
				end
			elseif right.min <= pmax[next_axis] then
				iterate(right, next_axis_i)
			end
		end
	end
	return iterate
end

function PointSearchTree:iterate_values_in_area(pmin, pmax)
	if not self._root then
		return function() end
	end

	pmin, pmax = vector.sort(pmin, pmax)

	if self._root.max < pmin.x or pmax.x < self._root.min then
		return function() end
	end

	return coroutine.wrap(function()
		make_iterator(pmin, pmax, function(leaf)
			return in_area(leaf[POS], pmin, pmax)
		end, function(leaf)
			coroutine.yield(leaf[POS], leaf[VALUE])
		end)(self._root, 1)
	end)
end

function PointSearchTree:get_values_in_area(pmin, pmax)
	local via = {}
	if not self._root then
		return via
	end

	pmin, pmax = vector.sort(pmin, pmax)

	if self._root.max < pmin.x or pmax.x < self._root.min then
		return via
	end

	make_iterator(pmin, pmax, function(leaf)
		return in_area(leaf[POS], pmin, pmax)
	end, function(leaf)
		via[#via + 1] = leaf[VALUE]
	end)(self._root, 1)

	return via
end

function PointSearchTree:iterate_values_inside_radius(center, radius)
	if not self._root then
		return function() end
	end

	local pmin = vector.subtract(center, radius)
	local pmax = vector.add(center, radius)

	if self._root.max < pmin.x or pmax.x < self._root.min then
		return function() end
	end

	local v_distance = vector.distance

	return coroutine.wrap(function()
		make_iterator(pmin, pmax, function(leaf)
			return v_distance(center, leaf[POS]) <= radius
		end, function(leaf)
			coroutine.yield(leaf[POS], leaf[VALUE])
		end)(self._root, 1)
	end)
end

function PointSearchTree:get_values_inside_radius(center, radius)
	local vir = {}
	if not self._root then
		return vir
	end

	local pmin = vector.subtract(center, radius)
	local pmax = vector.add(center, radius)

	if self._root.max < pmin.x or pmax.x < self._root.min then
		return vir
	end

	local v_distance = vector.distance

	make_iterator(pmin, pmax, function(leaf)
		return v_distance(center, leaf[POS]) <= radius
	end, function(leaf)
		vir[#vir + 1] = leaf[VALUE]
	end)(self._root, 1)

	return vir
end

futil.PointSearchTree = PointSearchTree
