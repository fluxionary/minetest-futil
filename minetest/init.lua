futil.dofile("minetest", "box")
futil.dofile("minetest", "dump")
futil.dofile("minetest", "fake_inventory")
futil.dofile("minetest", "group")
futil.dofile("minetest", "image")
futil.dofile("minetest", "item")
futil.dofile("minetest", "registration")
futil.dofile("minetest", "serialization")
futil.dofile("minetest", "strip_translation")
futil.dofile("minetest", "texture")
futil.dofile("minetest", "time")
futil.dofile("minetest", "vector")

if INIT == "game" then
	futil.dofile("minetest", "globalstep")
	futil.dofile("minetest", "hud_ephemeral")
	futil.dofile("minetest", "hud_manager")
	futil.dofile("minetest", "inventory")
	futil.dofile("minetest", "object")
	futil.dofile("minetest", "object_properties")
	futil.dofile("minetest", "player")
	futil.dofile("minetest", "raycast")
end
