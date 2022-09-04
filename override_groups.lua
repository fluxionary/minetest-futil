

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
