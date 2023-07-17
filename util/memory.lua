-- i have no idea how accurate this is, i use documentation from the below link for a few things
-- https://wowwiki-archive.fandom.com/wiki/Lua_object_memory_sizes

local function estimate_memory_usage(thing, seen)
	local typ = type(thing)
	if typ == "nil" or typ == "boolean" then
		return 0
	elseif typ == "number" then
		return 8 -- this is probably larger
	elseif typ == "string" then
		return 24 + typ:len()
	elseif typ == "function" then
		-- TODO: we can calculate the usage of closures, but that's complicated
		return 20
	elseif typ == "userdata" then
		return 0 -- this is probably larger
	elseif typ == "thread" then
		return 0 -- this is probably larger
	elseif typ == "table" then
		seen = seen or {}
		if seen[thing] then
			return 0
		end
		seen[thing] = true
		if #thing > 0 then
			-- assume list
			local size = 40 + 16 * #thing
			for i = 1, #thing do
				size = size + estimate_memory_usage(thing[i], seen)
			end
			return size
		else
			local size = 40
			for k, v in pairs(thing) do
				size = size + 40 + estimate_memory_usage(k, seen) + estimate_memory_usage(v, seen)
			end
			return size
		end
	else
		futil.log("warning", "estimate_memory_usage: unknown type %s", typ)
		return 0 -- ????
	end
end

futil.estimate_memory_usage = estimate_memory_usage
