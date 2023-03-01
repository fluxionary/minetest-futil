local FakeInventory = futil.class1()

local function copy_list(list)
	local copy = {}
	for i = 1, #list do
		copy[i] = ItemStack(list[i])
	end
	return copy
end

function FakeInventory:_init()
	self._lists = {}
end

function FakeInventory.create_copy(inv)
	local fake_inv = FakeInventory()
	for listname, contents in pairs(inv:get_lists()) do
		fake_inv:set_size(listname, inv:get_size(listname))
		fake_inv:set_width(listname, inv:get_width(listname))
		fake_inv:set_list(listname, contents)
	end
	return fake_inv
end

function FakeInventory.room_for_all(inv, listname, items)
	local fake_inv = FakeInventory.create_copy(inv)
	for i = 1, #items do
		local item = items[i]
		local remainder = fake_inv:add_item(listname, item)
		if not remainder:is_empty() then
			return false
		end
	end
	return true
end

function FakeInventory:is_empty(listname)
	local list = self._lists[listname]
	if not list then
		return true
	end
	for _, stack in ipairs(list) do
		if not stack:is_empty() then
			return false
		end
	end
	return true
end

function FakeInventory:get_size(listname)
	local list = self._lists[listname]
	if not list then
		return 0
	end
	return #list
end

function FakeInventory:set_size(listname, size)
	if size == 0 then
		self._lists[listname] = nil
		return
	end

	local list = self._lists[listname] or {}

	while #list < size do
		list[#list + 1] = ItemStack()
	end

	for i = size + 1, #list do
		list[i] = nil
	end

	self._lists[listname] = list
end

function FakeInventory:get_width(listname)
	local list = self._lists[listname] or {}
	return list.width or 0
end

function FakeInventory:set_width(listname, width)
	local list = self._lists[listname] or {}
	list.width = width
	self._lists[listname] = list
end

function FakeInventory:get_stack(listname, i)
	local list = self._lists[listname]
	if not list or i > #list then
		return ItemStack()
	end
	return ItemStack(list[i])
end

function FakeInventory:set_stack(listname, i, stack)
	local list = self._lists[listname]
	if not list or i > #list then
		return
	end
	list[i] = ItemStack(stack)
end

function FakeInventory:get_list(listname)
	local list = self._lists[listname]
	if not list then
		return
	end
	return copy_list(list)
end

function FakeInventory:set_list(listname, list)
	local ourlist = self._lists[listname]
	if not ourlist then
		return
	end

	for i = 1, math.min(#ourlist, #list) do
		ourlist[i] = ItemStack(list[i])
	end
end

function FakeInventory:get_lists()
	local lists = {}
	for listname, list in pairs(self._lists) do
		lists[listname] = copy_list(list)
	end
	return lists
end

function FakeInventory:set_lists(lists)
	for listname, list in pairs(lists) do
		self:set_list(listname, list)
	end
end

-- add item somewhere in list, returns leftover `ItemStack`.
function FakeInventory:add_item(listname, stack)
	local list = self._lists[listname]
	stack = ItemStack(stack)
	if not list then
		return stack
	end

	for _, our_stack in ipairs(list) do
		stack = our_stack:add_item(stack)
		if stack:is_empty() then
			break
		end
	end

	return stack
end

-- returns `true` if the stack of items can be fully added to the list
function FakeInventory:room_for_item(listname, stack)
	local list = self._lists[listname]
	if not list then
		return false
	end

	stack = ItemStack(stack)
	local copy = copy_list(list)
	for _, our_stack in ipairs(copy) do
		stack = our_stack:add_item(stack)
		if stack:is_empty() then
			break
		end
	end

	return stack:is_empty()
end

-- take as many items as specified from the list, returns the items that were actually removed (as an `ItemStack`)
-- note that any item metadata is ignored, so attempting to remove a specific unique item this way will likely remove
-- the wrong one -- to do that use `set_stack` with an empty `ItemStack`.
function FakeInventory:remove_item(listname, stack)
	local removed = ItemStack()
	stack = ItemStack(stack)

	local list = self._lists[listname]
	if not list or stack:is_empty() then
		return removed
	end

	local name = stack:get_name()
	local count_remaining = stack:get_count()
	local taken = 0

	for _, our_stack in ipairs(list) do
		if our_stack:get_name() == name then
			local n = our_stack:take_item(count_remaining):get_count()
			count_remaining = count_remaining - n
			taken = taken + n
		end

		if count_remaining == 0 then
			break
		end
	end

	stack:set_count(taken)

	return stack
end

-- returns `true` if the stack of items can be fully taken from the list.
-- If `match_meta` is false, only the items' names are compared (default: `false`).
function FakeInventory:contains_item(listname, stack, match_meta)
	local list = self._lists[listname]
	if not list then
		return false
	end

	stack = ItemStack(stack)

	if match_meta then
		local name = stack:get_name()
		local wear = stack:get_wear()
		local meta = stack:get_meta()
		local needed_count = stack:get_count()

		for _, our_stack in ipairs(list) do
			if our_stack:get_name() == name and our_stack:get_wear() == wear and our_stack:get_meta():equals(meta) then
				local n = our_stack:peek_item(needed_count):get_count()
				needed_count = needed_count - n
			end
			if needed_count == 0 then
				break
			end
		end

		return needed_count == 0
	else
		local name = stack:get_name()
		local needed_count = stack:get_count()

		for _, our_stack in ipairs(list) do
			if our_stack:get_name() == name then
				local n = our_stack:peek_item(needed_count):get_count()
				needed_count = needed_count - n
			end
			if needed_count == 0 then
				break
			end
		end

		return needed_count == 0
	end
end

futil.FakeInventory = FakeInventory
