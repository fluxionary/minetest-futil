
function futil.parse_lua(code)
	local f = loadstring(("return %s"):format(code))
	if f then
		return f()
	end
end


function futil.serialize(x)
	if type(x) == "number" or type(x) == "boolean" or type(x) == "nil" then
		return tostring(x)
	elseif type(x) == "string" then
		return ("%q"):format(x)
	elseif type(x) == "table" then
		local parts = {}
		for k, v in futil.pairs_by_key(x) do
			table.insert(parts, ("[%s] = %s"):format(futil.serialize(k), futil.serialize(v)))
		end
		return ("{%s}"):format(table.concat(parts, ", "))
	else
		error(("can't serialize type %s"):format(type(x)))
	end
end

function futil.serialize_invlist(inv, listname)
	local itemstrings = {}
	local list = inv:get_list(listname)
	if not list then
		error(("couldn't find %s of %s"):format(listname, minetest.write_json(inv:get_location())))
	end
	for _, stack in ipairs(list) do
		if not stack:is_empty() then
			table.insert(itemstrings, stack:to_string())
		end
	end
	return minetest.write_json(itemstrings)
end

function futil.deserialize_invlist(serialized_inv, inv, listname)
	if not inv:is_empty(listname) then
		error(("trying to deserialize into a non-empty list %s (%s)"):format(listname, serialized_inv))
	end

	local itemstrings = minetest.parse_json(serialized_inv)

	inv:set_size(listname, #itemstrings)

	for _, itemstring in ipairs(itemstrings) do
		local remainder = inv:add_item(listname, itemstring)
		if not remainder:is_empty() then
			futil.log("error", "lost %s", remainder:to_string())
		end
	end
end
