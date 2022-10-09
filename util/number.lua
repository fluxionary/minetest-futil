local max = math.max
local min = math.min

function futil.bound(m, v, M)
	return max(m, min(v, M))
end

function futil.in_bounds(m, v, M)
	return m <= v and v <= M
end
