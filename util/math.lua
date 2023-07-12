futil.math = {}

local floor = math.floor
local max = math.max
local min = math.min

function futil.math.idiv(a, b)
	local rem = a % b
	return (a - rem) / b, rem
end

function futil.math.bound(m, v, M)
	return max(m, min(v, M))
end

function futil.math.in_bounds(m, v, M)
	return m <= v and v <= M
end

local in_bounds = futil.math.in_bounds

function futil.math.is_integer(v)
	return floor(v) == v
end

local is_integer = futil.math.is_integer

function futil.math.is_u8(i)
	return (type(i) == "number" and is_integer(i) and in_bounds(0, i, 0xFF))
end

function futil.math.is_u16(i)
	return (type(i) == "number" and is_integer(i) and in_bounds(0, i, 0xFFFF))
end

function futil.math.sum(t, initial)
	local sum
	local start
	if initial then
		sum = initial
		start = 1
	else
		sum = t[1]
		start = 2
	end

	for i = start, #t do
		sum = sum + t[i]
	end

	return sum
end

function futil.math.isum(i, initial)
	local sum

	if initial == nil then
		sum = i()
	else
		sum = initial
	end

	local v = i()

	while v do
		sum = sum + v
		v = i()
	end

	return sum
end

function futil.math.probabilistic_round(v)
	return math.floor(v + math.random())
end

function futil.math.cmp(a, b)
	return a < b
end

function futil.math.deg2rad(deg)
	return deg * math.pi / 180
end

function futil.math.rad2deg(rad)
	return rad * 180 / math.pi
end
