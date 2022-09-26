local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname)
local S = minetest.get_translator(modname)

futil = {
	author = "fluxionary",
	license = "AGPL_v3",
	version = {year = 2022, month = 9, day = 4},
	fork = "fluxionary",

	modname = modname,
	modpath = modpath,
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

futil.dofile("class")

futil.dofile("deque")
futil.dofile("exception")
futil.dofile("group")
futil.dofile("inventory")
futil.dofile("item")
futil.dofile("memoization")
futil.dofile("number")
futil.dofile("pairing_heap")
futil.dofile("position")
futil.dofile("serialization")
futil.dofile("string")
futil.dofile("strip_translation")
futil.dofile("table")
futil.dofile("texture")
futil.dofile("time")
