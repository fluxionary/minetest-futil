local in_bounds = futil.in_bounds
local bound = futil.bound

local map_blocksize = 16
local chunksize = tonumber(minetest.settings:get("chunksize")) or 5
local max_mapgen_limit = 31007
local mapgen_limit = tonumber(minetest.settings:get("mapgen_limit")) or max_mapgen_limit
local mapgen_limit_b = math.floor(bound(0, mapgen_limit, max_mapgen_limit) / map_blocksize)
local mapgen_limit_min = -mapgen_limit_b * map_blocksize
local mapgen_limit_max = (mapgen_limit_b + 1) * map_blocksize - 1

local min_i = mapgen_limit_min + (map_blocksize * chunksize)
local max_i = mapgen_limit_max - (map_blocksize * chunksize)

local min_p = vector.new(min_i, min_i, min_i)
local max_p = vector.new(max_i, max_i, max_i)

function futil.get_blockpos(pos)
    return vector.new(math.floor(pos.x / 16), math.floor(pos.y / 16), math.floor(pos.z / 16))
end

function futil.get_block_bounds(blockpos)
    return vector.new(blockpos.x * 16, blockpos.y * 16, blockpos.z * 16),
    vector.new(blockpos.x * 16 + 15, blockpos.y * 16 + 15, blockpos.z * 16 + 15)
end

function futil.formspec_pos(pos)
	return ("%i,%i,%i"):format(pos.x, pos.y, pos.z)
end

function futil.iterate_area(minp, maxp)
	local cur = table.copy(minp)
	cur.x = cur.x - 1
	return function()
		if cur.z > maxp.z then
			return
		end

		cur.x = cur.x + 1
		if cur.x > maxp.x then
			cur.x = minp.x
			cur.y = cur.y + 1
		end

		if cur.y > maxp.y then
			cur.y = minp.y
			cur.z = cur.z + 1
		end

		if cur.z <= maxp.z then
			return vector.copy(cur)
		end
	end
end

function futil.iterate_volume(pos, radius)
	return futil.iterate_area(vector.subtract(pos, radius), vector.add(pos, radius))
end

function futil.get_world_bounds()
	return min_p, max_p
end

function futil.is_inside_world_bounds(pos)
	local x = pos.x
	local y = pos.y
	local z = pos.z
	return (
		in_bounds(min_i, x, max_i) and
		in_bounds(min_i, y, max_i) and
		in_bounds(min_i, z, max_i)
	)
end

function futil.bound_position_to_world(pos)
	return vector.new(
		bound(min_i, pos.x, max_i),
		bound(min_i, pos.y, max_i),
		bound(min_i, pos.z, max_i)
	)
end
