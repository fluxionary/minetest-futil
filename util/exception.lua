function futil.check_call(func, rv_on_fail)
	-- wrap a function w/ logic to avoid crashing the game
	return function(...)
		local rvs = {xpcall(func, debug.traceback, ...)}

		if rvs[1] then
            table.remove(rvs, 1)
            return unpack(rvs)

		else
			futil.log("error", "(check_call): %s args: %s out: %s", dump(debug.getinfo(func)), dump({...}), rvs[2])
            return rv_on_fail
		end
	end
end
