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

--[[
alternative version:
return (
	item1:get_name() == item2:get_name() and
	item1:get_count() == item2:get_count() and
	item1:get_wear() == item2:get_wear() and
	item1:get_meta():equals(item2:get_meta())
)
]]
function futil.items_equals(item1, item2)
	return futil.equals(ItemStack(item1):to_table(), ItemStack(item2):to_table())
end
