local f = string.format

-- if allow_unregistered is false or absent, if the original item or its alias is not a registered item, will return nil
function futil.resolve_item(item_or_string, allow_unregistered)
	local item_stack = ItemStack(item_or_string)
	local name = item_stack:get_name()

	local seen = { [name] = true }

	local alias = minetest.registered_aliases[name]
	while alias do
		name = alias
		seen[name] = true
		alias = minetest.registered_aliases[name]
		if seen[alias] then
			error(f("alias cycle on %s", name))
		end
	end

	if minetest.registered_items[name] or allow_unregistered then
		item_stack:set_name(name)
		return item_stack:to_string()
	end
end

function futil.resolve_itemstack(item_or_string)
	return ItemStack(futil.resolve_item(item_or_string, true))
end

if ItemStack().equals then
	-- https://github.com/minetest/minetest/pull/12771
	function futil.items_equals(item1, item2)
		item1 = type(item1) == "userdata" and item1 or ItemStack(item1)
		item2 = type(item2) == "userdata" and item2 or ItemStack(item2)

		return item1 == item2
	end
else
	local equals = futil.equals

	function futil.items_equals(item1, item2)
		item1 = type(item1) == "userdata" and item1 or ItemStack(item1)
		item2 = type(item2) == "userdata" and item2 or ItemStack(item2)

		return equals(item1:to_table(), item2:to_table())
	end
end

function futil.get_primary_drop(stack)
	if type(stack) == "string" then
		stack = ItemStack(stack)
	end

	local name = stack:get_name()
	local def = stack:get_definition()
	local drop = def.drop

	if drop == nil then
		return name
	elseif drop == "" then
		return nil
	elseif type(drop) == "string" then
		return drop
	elseif type(drop) == "table" then
		local most_common_item
		local rarity = tonumber("inf")

		if not drop.items then
			error(f("unexpected drop table: %s", dump(drop)))
		end

		for _, item in ipairs(drop.items) do
			if not (item.tools or item.tool_groups) then
				if (item.rarity or 1) < rarity then
					most_common_item = item.items[1]
					rarity = item.rarity
				end
			end
		end

		return most_common_item
	else
		error(f("invalid drop of %s? %q", dump(name, drop)))
	end
end
