fmod.check_version({ year = 2023, month = 7, day = 12 }) -- futil in async

futil = fmod.create()

futil.dofile("util", "init")
futil.dofile("collections", "init") -- depends on util
futil.dofile("minetest", "init") -- depends on util

if INIT == "game" then
	minetest.register_async_dofile(futil.modpath .. DIR_DELIM .. "init.lua")
end
