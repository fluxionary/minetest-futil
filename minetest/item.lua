function futil.resolve_item(item)
	local item_stack = ItemStack(item)
	local name = item_stack:get_name()

	local alias = minetest.registered_aliases[name]
	while alias do
		name = alias
		alias = minetest.registered_aliases[name]
	end

	if minetest.registered_items[name] then
		item_stack:set_name(name)
		return item_stack:to_string()
	end
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
	if not drop then
		return name

	elseif type(drop) == "" then
		return nil
	end
end
