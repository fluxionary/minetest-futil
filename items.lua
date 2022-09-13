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
