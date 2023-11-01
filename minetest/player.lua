function futil.is_player(obj)
	return minetest.is_player(obj) and not obj.is_fake_player
end
