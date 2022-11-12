function futil.DefaultTable(initializer)
	return setmetatable({}, {__index = function(t, k)
		local v = initializer(k)
		t[k] = v
		return v
	end})
end
