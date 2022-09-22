

function futil.check_call(func)
	-- wrap a function w/ logic to avoid crashing the game
	return function(...)
		local status, out = pcall(func, ...)

		if status then
			return out

		else
			futil.log("error", "(check_call): %s args: %s out: %s", dump(debug.getinfo(func)), dump({...}), out)
		end
	end
end
