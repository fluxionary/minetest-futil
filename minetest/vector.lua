local m_min = math.min
local m_max = math.max
local m_floor = math.floor

local in_bounds = futil.math.in_bounds
local bound = futil.math.bound

local mapblock_size = 16
local chunksize = m_floor(tonumber(minetest.settings:get("chunksize")) or 5)
local max_mapgen_limit = 31007
local mapgen_limit = m_floor(tonumber(minetest.settings:get("mapgen_limit")) or max_mapgen_limit)
local mapgen_limit_b = m_floor(bound(0, mapgen_limit, max_mapgen_limit) / mapblock_size)
local mapgen_limit_min = -mapgen_limit_b * mapblock_size
local mapgen_limit_max = (mapgen_limit_b + 1) * mapblock_size - 1

local map_min_i = mapgen_limit_min + (mapblock_size * chunksize)
local map_max_i = mapgen_limit_max - (mapblock_size * chunksize)

local v_add = vector.add
local v_new = vector.new
local v_sort = vector.sort
local v_sub = vector.subtract

local map_min_p = v_new(map_min_i, map_min_i, map_min_i)
local map_max_p = v_new(map_max_i, map_max_i, map_max_i)

futil.vector = {}

function futil.get_bounds(pos, radius)
	return v_sub(pos, radius), v_add(pos, radius)
end

function futil.get_blockpos(pos)
	return v_new(m_floor(pos.x / mapblock_size), m_floor(pos.y / mapblock_size), m_floor(pos.z / mapblock_size))
end

function futil.get_block_bounds(blockpos)
	return v_new(blockpos.x * mapblock_size, blockpos.y * mapblock_size, blockpos.z * mapblock_size),
		v_new(
			blockpos.x * mapblock_size + (mapblock_size - 1),
			blockpos.y * mapblock_size + (mapblock_size - 1),
			blockpos.z * mapblock_size + (mapblock_size - 1)
		)
end

function futil.formspec_pos(pos)
	return ("%i,%i,%i"):format(pos.x, pos.y, pos.z)
end

function futil.iterate_area(minp, maxp)
	minp, maxp = v_sort(minp, maxp)
	local min_x = minp.x
	local min_z = minp.z

	local x = min_x - 1
	local y = minp.y
	local z = min_z

	local max_x = maxp.x
	local max_y = maxp.y
	local max_z = maxp.z

	return function()
		if y > max_y then
			return
		end

		x = x + 1
		if x > max_x then
			x = min_x
			z = z + 1
		end

		if z > max_z then
			z = min_z
			y = y + 1
		end

		if y <= max_y then
			return v_new(x, y, z)
		end
	end
end

function futil.iterate_volume(pos, radius)
	return futil.iterate_area(futil.get_bounds(pos, radius))
end

function futil.is_pos_in_bounds(minp, pos, maxp)
	minp, maxp = v_sort(minp, maxp)
	return (in_bounds(minp.x, pos.x, maxp.x) and in_bounds(minp.y, pos.y, maxp.y) and in_bounds(minp.z, pos.z, maxp.z))
end

function futil.get_world_bounds()
	return map_min_p, map_max_p
end

function futil.is_inside_world_bounds(pos)
	return futil.is_pos_in_bounds(map_min_p, pos, map_max_p)
end

function futil.bound_position_to_world(pos)
	return v_new(
		bound(map_min_i, pos.x, map_max_i),
		bound(map_min_i, pos.y, map_max_i),
		bound(map_min_i, pos.z, map_max_i)
	)
end

function futil.vector.volume(pos1, pos2)
	local minp, maxp = v_sort(pos1, pos2)
	return (maxp.x - minp.x + 1) * (maxp.y - minp.y + 1) * (maxp.z - minp.z + 1)
end

function futil.split_region_by_mapblock(pos1, pos2, num_blocks)
	local chunk_size = 16 * (num_blocks or 1)
	local chunk_span = chunk_size - 1

	pos1, pos2 = v_sort(pos1, pos2)

	local x1 = pos1.x - (pos1.x % chunk_size)
	local x2 = pos2.x - (pos2.x % chunk_size) + chunk_span
	local y1 = pos1.y - (pos1.y % chunk_size)
	local y2 = pos2.y - (pos2.y % chunk_size) + chunk_span
	local z1 = pos1.z - (pos1.z % chunk_size)
	local z2 = pos2.z - (pos2.z % chunk_size) + chunk_span

	local chunks = {}
	for y = y1, y2, chunk_size do
		local y_min = m_max(pos1.y, y)
		local y_max = m_min(pos2.y, y + chunk_span)

		for x = x1, x2, chunk_size do
			local x_min = m_max(pos1.x, x)
			local x_max = m_min(pos2.x, x + chunk_span)

			for z = z1, z2, chunk_size do
				local z_min = m_max(pos1.z, z)
				local z_max = m_min(pos2.z, z + chunk_span)

				table.insert(chunks, { v_new(x_min, y_min, z_min), v_new(x_max, y_max, z_max) })
			end
		end
	end

	return chunks
end
