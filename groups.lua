

function futil.add_groups(itemstring, new_groups)
    local def = minetest.registered_items[itemstring]
    if not def then
        error(("attempting to override unknown item %s"):format(itemstring))
    end
    local groups = table.copy(def.groups or {})
    for group, value in pairs(new_groups) do
        groups[group] = value
    end
    minetest.override_item(itemstring, {groups = groups})
end

function futil.remove_groups(itemstring, ...)
    local def = minetest.registered_items[itemstring]
    if not def then
        error(("attempting to override unknown item %s"):format(itemstring))
    end
    local groups = table.copy(def.groups or {})
    for _, group in ipairs({...}) do
        groups[group] = nil
    end
    minetest.override_item(itemstring, {groups = groups})
end

function futil.get_items_with_group(group)
	local items_by_group = futil.items_by_group

	if items_by_group then
		return items_by_group[group] or {}
	end

	local items = {}

	for item in pairs(minetest.registered_items) do
		if minetest.get_item_group(item, group) > 0 then
			table.insert(items, item)
		end
	end

	return items
end

minetest.register_on_mods_loaded(function()
	local items_by_group = {}

	for item, def in pairs(minetest.registered_items) do
		for group in ipairs(def.groups or {}) do
			local items = items_by_group[group] or {}
			table.insert(items, item)
			items_by_group[group] = items
		end
	end

	futil.items_by_group = items_by_group
end)
