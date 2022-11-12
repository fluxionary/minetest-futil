local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname)
local S = minetest.get_translator(modname)

futil = {
	author = "fluxionary",
	license = "AGPL_v3",
	version = os.time({year = 2022, month = 11, day = 11}),
	fork = "fluxionary",

	modname = modname,
	modpath = modpath,
	mod_storage = minetest.get_mod_storage(),
	S = S,

	has = {
	},

	log = function(level, messagefmt, ...)
		return minetest.log(level, ("[%s] %s"):format(modname, messagefmt:format(...)))
	end,

	dofile = function(...)
		return dofile(table.concat({modpath, ...}, DIR_DELIM) .. ".lua")
	end,
}

futil.dofile("util", "init")
futil.dofile("collections", "init") -- depends on util
futil.dofile("minetest", "init") -- depends on util

futil.mod_storage = nil
