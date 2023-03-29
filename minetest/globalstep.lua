function futil.register_globalstep(def)
	if def.period then
		local elapsed = 0
		if def.catchup == "full" then
			assert(def.period > 0, "full catchup will cause an infinite loop if period is 0")
			minetest.register_globalstep(function(dtime)
				elapsed = elapsed + dtime
				if elapsed < def.period then
					return
				end
				elapsed = elapsed - def.period
				def.func(def.period)
				while elapsed > def.period do
					elapsed = elapsed - def.period
					def.func(def.period)
				end
			end)
		elseif def.catchup == "single" or def.catchup == true then
			minetest.register_globalstep(function(dtime)
				elapsed = elapsed + dtime
				if elapsed < def.period then
					return
				end
				elapsed = elapsed - def.period
				def.func(def.period)
			end)
		else
			-- no catchup, just reset
			minetest.register_globalstep(function(dtime)
				elapsed = elapsed + dtime
				if elapsed < def.period then
					return
				end
				def.func(elapsed)
				elapsed = 0
			end)
		end
	else
		-- we do nothing useful
		minetest.register_globalstep(function(dtime)
			def.func(dtime)
		end)
	end
end
