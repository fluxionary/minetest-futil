--local DefaultTable = futil.class1()
--
--function DefaultTable:_init(initializer)
--	-- TODO should check that initializer is executable
--	rawset(self, "_initializer", initializer)
--	rawset(self, "_contents", {})
--end
--
--function DefaultTable:__index(key)
--	local contents = rawget(self, "_contents")
--	local value = contents[key]
--
--	if value == nil then
--		local initializer = rawget(self, "_initializer")
--		value = initializer(key)
--		contents[key] = value
--	end
--
--	return value
--end
--
--function DefaultTable:__newindex(key, value)
--	local contents = rawget(self, "_contents")
--	contents[key] = value
--end

function futil.DefaultTable(initializer)
	return setmetatable({}, {__index = function(t, k)
		local v = initializer(k)
		t[k] = v
		return v
	end})
end
