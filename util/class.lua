function futil.class1(super)
	local meta = {
		__call = function(class, ...)
	        local obj = setmetatable({}, class)
	        if obj._init then
	            obj:_init(...)
	        end
	        return obj
	    end
	}

	if super then
		meta.__index = super
	end

    local class = {}
	class.__index = class

	setmetatable(class, meta)

    return class
end

function futil.class(...)
	local meta = {
		__call = function(class, ...)
	        local obj = setmetatable({}, class)
	        if obj._init then
	            obj:_init(...)
	        end
	        return obj
	    end
	}

	local parents = {...}
	if #parents > 0 then
		meta.__index = function(self, key)
			for i = #parents, 1, -1 do
				local v = parents[i][key]
				if v then
					return v
				end
			end
		end
	end

    local class = {}
	class.__index = class
	setmetatable(class, meta)

	function class:is_a(class2)
		if class == class2 then
			return true
		end

		for _, parent in ipairs(parents) do
			if parent:is_a(class2) then
				return true
			end
		end

		return false
	end

    return class
end
