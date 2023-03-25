--[[
local my_hud = futil.define_hud("my_hud", {
	period = 1,
	get_hud_def = function(player)
		return {}
	end,
})
]]

local f = string.format

local Hud = futil.class1()

function Hud:_init(hud_name, def)
	self.name = hud_name
	self._name_field = def.name_field or "name"
	self._period = def.period or 0
	self._get_hud_def = def.get_hud_def
	self._hud_id_by_player_name = {}

	self._hud_enabled_key = f("hud_manager:%s_enabled", hud_name)
	self._hud_name = f("hud_manager:%s", hud_name)
end

function Hud:is_enabled(player)
	local meta = player:get_meta()
	return minetest.is_yes(meta:get(self._hud_enabled_key))
end

function Hud:toggle_enabled(player)
	local meta = player:get_meta()
	local enabled = not minetest.is_yes(meta:get(self._hud_enabled_key))
	if enabled then
		meta:set_string(self._hud_enabled_key, "y")
	else
		meta:set_string(self._hud_enabled_key, "")
	end
	return enabled
end

function Hud:update(player)
	local is_enabled = self:is_enabled(player)
	local player_name = player:get_player_name()
	local hud_id = self._hud_id_by_player_name[player_name]
	local old_hud_def
	if hud_id then
		old_hud_def = player:hud_get(hud_id)
		if old_hud_def and old_hud_def[self._name_field] == self._hud_name then
			if not is_enabled then
				player:hud_remove(hud_id)
				self._hud_id_by_player_name[player_name] = nil
				return
			end
		else
			-- hud_id is bad
			hud_id = nil
			old_hud_def = nil
		end
	end

	if is_enabled then
		local new_hud_def = self._get_hud_def(player)
		if not new_hud_def then
			if hud_id then
				player:hud_remove(hud_id)
				self._hud_id_by_player_name[player_name] = nil
			end
			return
		elseif new_hud_def[self._name_field] then
			error("you cannot specify the value of the name field, this is generated")
		end

		if old_hud_def then
			for k, v in pairs(new_hud_def) do
				if old_hud_def[k] ~= v then
					if k == "hud_elem_type" then
						error(f("cannot change hud_elem_type (%s -> %s)", old_hud_def[k], v))
					end
					player:hud_change(hud_id, k, v)
				end
			end
		else
			new_hud_def[self._name_field] = self._hud_name
			hud_id = player:hud_add(new_hud_def)
		end
	end

	self._hud_id_by_player_name[player_name] = hud_id
end

futil.defined_huds = {}

function futil.define_hud(hud_name, def)
	if futil.defined_huds[hud_name] then
		error(f("hud %s already exists", hud_name))
	end
	local hud = Hud(hud_name, def)
	futil.defined_huds[hud_name] = hud
	return hud
end

local elapsed_by_hud_name = {}
minetest.register_globalstep(function(dtime)
	local players = minetest.get_connected_players()
	for hud_name, hud in pairs(futil.defined_huds) do
		local elapsed = (elapsed_by_hud_name[hud_name] or 0) + dtime
		if elapsed < hud._period then
			elapsed_by_hud_name[hud_name] = elapsed
		else
			elapsed_by_hud_name[hud_name] = 0
			for i = 1, #players do
				hud:update(players[i])
			end
		end
	end
end)
