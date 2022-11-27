function futil.get_location_string(inv)
	local location = inv:get_location()
	if location.type == "node" then
		return ("nodemeta:%i,%i,%i"):format(location.pos.x, location.pos.y, location.pos.z)
	elseif location.type == "player" then
		return ("player:%s"):format(location.name)
	elseif location.type == "detached" then
		return ("detached:%s"):format(location.name)
	else
		error(("unexpected location? %s"):format(dump(location)))
	end
end
