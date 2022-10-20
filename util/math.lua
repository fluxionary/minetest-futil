-- luacheck: globals math

local floor = math.floor
local max = math.max
local min = math.min

function math.idiv(a, b)
	local rem = (a % b)
	return (a - rem) / b, rem
end

function math.bound(m, v, M)
	return max(m, min(v, M))
end

function math.in_bounds(m, v, M)
	return m <= v and v <= M
end

function math.is_integer(v)
	return floor(v) == v
end
