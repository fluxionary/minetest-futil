function futil.memoize1(f)
	local memo = {}
	return function(arg)
		if arg == nil then
			return f(arg)
		end
		local rv = memo[arg]

		if not rv then
			rv = f(arg)
			memo[arg] = rv
		end

		return rv
	end
end
