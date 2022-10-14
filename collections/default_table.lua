local DefaultTable = futil.class1()

function DefaultTable:_init(initializer)
	-- TODO should check that initializer is executable
	self._initializer = initializer
	self._contents = {}
end

function DefaultTable:__index(key)
	local value = self._contents[key]
	if not value then
		value = self._initializer()
		self._contents[key] = value
	end
	return value
end

function DefaultTable:__newindex(key, value)
	self._contents[key] = value
end
