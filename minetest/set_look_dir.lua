local pi = math.pi
function futil.set_look_dir(player, look_dir)
	local pitch = math.asin(-look_dir.y)
	local yaw = math.atan2(look_dir.z, look_dir.x)
	player:set_look_vertical(pitch)
	player:set_look_horizontal((yaw + 1.5 * pi) % (2.0 * pi))
end
