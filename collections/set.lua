local f = string.format

local Set = futil.class1()

local function is_a_set(thing)
	return type(thing) == "table" and type(thing.is_a) == "function" and thing:is_a(Set)
end

function Set:_init(t_or_i)
	self._size = 0
	self._set = {}
	if t_or_i then
		if type(t_or_i.is_a) == "function" then
			if t_or_i:is_a(Set) then
				self._set = table.copy(t_or_i._set)
				self._size = t_or_i._size
			else
				for v in t_or_i:iterate() do
					self:add(v)
				end
			end
		elseif type(t_or_i) == "table" then
			for i = 1, #t_or_i do
				self:add(t_or_i[i])
			end
		else
			for v in t_or_i do
				self:add(v)
			end
		end
	end
end

function Set:__len()
	return self._size
end

function Set:__eq(other)
	if not is_a_set(other) then
		return false
	end
	for k in pairs(self._set) do
		if not other._set[k] then
			return false
		end
	end
	return self._size == other._size
end

function Set:contains(element)
	return self._set[element] == true
end

function Set:add(element)
	if not self._set[element] then
		self._set[element] = true
		self._size = self._size + 1
	end
end

function Set:remove(element)
	if not self._set[element] then
		error(f("set does not contain %s", element))
	end
	self._set[element] = nil
	self._size = self._size - 1
end

function Set:discard(element)
	if self._set[element] then
		self._set[element] = nil
		self._size = self._size - 1
	end
end

function Set:clear()
	self._set = {}
	self._size = 0
end

function Set:iterate()
	local i = pairs(self._set)
	local element
	return function()
		element = i(self._set, element)
		return element
	end
end

function Set:isdisjoint(other)
	if not is_a_set(other) then
		error("other is not a set")
	end
	for element in self:iterate() do
		if other:contains(element) then
			return false
		end
	end
	return true
end

function Set:issubset(other)
	if not is_a_set(other) then
		error("other is not a set")
	end
	if #self > #other then
		return false
	end
	for element in self:iterate() do
		if not other:contains(element) then
			return false
		end
	end
	return true
end

function Set:__le(other)
	return self:issubset(other)
end

function Set:__lt(other)
	if not is_a_set(other) then
		error("other is not a set")
	end
	if #self >= #other then
		return false
	end
	for element in self:iterate() do
		if not other:contains(element) then
			return false
		end
	end
	return true
end

function Set:issuperset(other)
	if not is_a_set(other) then
		error("other is not a set")
	end
	return other:issubset(self)
end

function Set:update(other)
	if not is_a_set(other) then
		error("other is not a set")
	end
	for element in other:iterate() do
		self:add(element)
	end
end

function Set:union(other)
	if not is_a_set(other) then
		error("other is not a set")
	end
	local union = Set(self)
	union:update(other)
	return union
end

function Set:__add(other)
	return self:union(other)
end

function Set:intersection_update(other)
	if not is_a_set(other) then
		error("other is not a set")
	end
	for element in self:iterate() do
		if not other:contains(element) then
			self:remove(element)
		end
	end
end

function Set:intersection(other)
	if not is_a_set(other) then
		error("other is not a set")
	end
	local intersection = Set()
	for element in self:iterate() do
		if other:contains(element) then
			intersection:add(element)
		end
	end
	return intersection
end

function Set:difference_update(other)
	if not is_a_set(other) then
		error("other is not a set")
	end
	for element in other:iterate() do
		self:discard(element)
	end
end

function Set:difference(other)
	if not is_a_set(other) then
		error("other is not a set")
	end
	local difference = Set(self)
	difference:difference_update(other)
	return difference
end

function Set:__sub(other)
	return self:difference(other)
end

futil.Set = Set
