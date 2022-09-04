function futil.resolve_item(item)
	local alias = minetest.registered_aliases[item]
	while alias do
		item = alias
		alias = minetest.registered_aliases[item]
	end

	if minetest.registered_items[item] then
		return item
	end
end
