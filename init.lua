futil = fmod.create()

futil.dofile("util", "init")
futil.dofile("collections", "init") -- depends on util
futil.dofile("minetest", "init") -- depends on util
