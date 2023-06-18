local m_acos = math.acos
local m_cos = math.cos
local m_floor = math.floor
local m_min = math.min
local m_max = math.max
local m_pi = math.pi
local m_random = math.random
local m_sin = math.sin

local v_add = vector.add
local v_new = vector.new
local v_sort = vector.sort
local v_sub = vector.subtract

local in_bounds = futil.math.in_bounds
local bound = futil.math.bound

local mapblock_size = 16 -- can be redefined, but effectively hard-coded
local chunksize = m_floor(tonumber(minetest.settings:get("chunksize")) or 5) -- # of mapblocks in a chunk (1 dim)
local chunksize_nodes = mapblock_size * chunksize -- # of nodes in a chunk (1 dim)
local max_mapgen_limit = 31007 -- hard coded
local mapgen_limit =
	bound(0, m_floor(tonumber(minetest.settings:get("mapgen_limit")) or max_mapgen_limit), max_mapgen_limit)
local mapgen_limit_b = m_floor(mapgen_limit / mapblock_size) -- # of mapblocks

-- *actual* minimum and maximum coordinates - one mapblock short of the theoretical min and max
local map_min_i = (-mapgen_limit_b * mapblock_size) + chunksize_nodes
local map_max_i = ((mapgen_limit_b + 1) * mapblock_size - 1) - chunksize_nodes

local map_min_p = v_new(map_min_i, map_min_i, map_min_i)
local map_max_p = v_new(map_max_i, map_max_i, map_max_i)

futil.vector = {}

function futil.vector.get_bounds(pos, radius)
	return v_sub(pos, radius), v_add(pos, radius)
end

futil.get_bounds = futil.vector.get_bounds

function futil.vector.get_world_bounds()
	return map_min_p, map_max_p
end

futil.get_world_bounds = futil.vector.get_world_bounds

function futil.vector.get_blockpos(pos)
	return v_new(m_floor(pos.x / mapblock_size), m_floor(pos.y / mapblock_size), m_floor(pos.z / mapblock_size))
end

futil.get_blockpos = futil.vector.get_blockpos

function futil.vector.get_block_bounds(blockpos)
	return v_new(blockpos.x * mapblock_size, blockpos.y * mapblock_size, blockpos.z * mapblock_size),
		v_new(
			blockpos.x * mapblock_size + (mapblock_size - 1),
			blockpos.y * mapblock_size + (mapblock_size - 1),
			blockpos.z * mapblock_size + (mapblock_size - 1)
		)
end

futil.get_block_bounds = futil.vector.get_block_bounds

function futil.vector.get_chunkpos(pos)
	return v_new(
		m_floor((pos.x - map_min_i) / chunksize_nodes),
		m_floor((pos.y - map_min_i) / chunksize_nodes),
		m_floor((pos.z - map_min_i) / chunksize_nodes)
	)
end

futil.get_chunkpos = futil.vector.get_chunkpos

function futil.vector.get_chunk_bounds(chunkpos)
	return v_new(
		chunkpos.x * chunksize_nodes + map_min_i,
		chunkpos.y * chunksize_nodes + map_min_i,
		chunkpos.z * chunksize_nodes + map_min_i
	),
		v_new(
			chunkpos.x * chunksize_nodes + map_min_i + (chunksize_nodes - 1),
			chunkpos.y * chunksize_nodes + map_min_i + (chunksize_nodes - 1),
			chunkpos.z * chunksize_nodes + map_min_i + (chunksize_nodes - 1)
		)
end

futil.get_chunk_bounds = futil.vector.get_chunk_bounds

function futil.vector.formspec_pos(pos)
	return ("%i,%i,%i"):format(pos.x, pos.y, pos.z)
end

futil.formspec_pos = futil.vector.formspec_pos

function futil.vector.iterate_area(minp, maxp)
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

futil.iterate_area = futil.vector.iterate_area

function futil.vector.iterate_volume(pos, radius)
	return futil.iterate_area(futil.get_bounds(pos, radius))
end

futil.iterate_volume = futil.vector.iterate_volume

function futil.is_pos_in_bounds(minp, pos, maxp)
	minp, maxp = v_sort(minp, maxp)
	return (in_bounds(minp.x, pos.x, maxp.x) and in_bounds(minp.y, pos.y, maxp.y) and in_bounds(minp.z, pos.z, maxp.z))
end

function futil.vector.is_inside_world_bounds(pos)
	return futil.is_pos_in_bounds(map_min_p, pos, map_max_p)
end

futil.is_inside_world_bounds = futil.vector.is_inside_world_bounds

function futil.vector.bound_position_to_world(pos)
	return v_new(
		bound(map_min_i, pos.x, map_max_i),
		bound(map_min_i, pos.y, map_max_i),
		bound(map_min_i, pos.z, map_max_i)
	)
end

futil.bound_position_to_world = futil.vector.bound_position_to_world

function futil.vector.volume(pos1, pos2)
	local minp, maxp = v_sort(pos1, pos2)
	return (maxp.x - minp.x + 1) * (maxp.y - minp.y + 1) * (maxp.z - minp.z + 1)
end

function futil.split_region_by_mapblock(pos1, pos2, num_blocks)
	local chunk_size = 16 * (num_blocks or 1)
	local chunk_span = chunk_size - 1

	pos1, pos2 = vector.sort(pos1, pos2)

	local min_x = pos1.x
	local min_y = pos1.y
	local min_z = pos1.z
	local max_x = pos2.x
	local max_y = pos2.y
	local max_z = pos2.z

	local x1 = min_x - (min_x % chunk_size)
	local x2 = max_x - (max_x % chunk_size) + chunk_span
	local y1 = min_y - (min_y % chunk_size)
	local y2 = max_y - (max_y % chunk_size) + chunk_span
	local z1 = min_z - (min_z % chunk_size)
	local z2 = max_z - (max_z % chunk_size) + chunk_span

	local chunks = {}
	for y = y1, y2, chunk_size do
		local y_min = m_max(min_y, y)
		local y_max = m_min(max_y, y + chunk_span)

		for x = x1, x2, chunk_size do
			local x_min = m_max(min_x, x)
			local x_max = m_min(max_x, x + chunk_span)

			for z = z1, z2, chunk_size do
				local z_min = m_max(min_z, z)
				local z_max = m_min(max_z, z + chunk_span)

				chunks[#chunks + 1] = { v_new(x_min, y_min, z_min), v_new(x_max, y_max, z_max) }
			end
		end
	end

	return chunks
end

function futil.random_unit_vector()
	local u = m_random()
	local v = m_random()
	local lambda = m_acos(2 * u - 1) - (m_pi / 2)
	local phi = 2 * m_pi * v
	return v_new(m_cos(lambda) * m_cos(phi), m_cos(lambda) * m_sin(phi), m_sin(lambda))
end

function futil.is_indoors(pos, distance, trials, hits_needed)
	distance = distance or 20
	trials = trials or 11
	hits_needed = hits_needed or 9
	local num_hits = 0
	for _ = 1, trials do
		local ruv = futil.random_unit_vector()
		local target = pos + (distance * ruv)
		if Raycast(pos, target, false, false)() then
			num_hits = num_hits + 1
			break
		end
	end
	return num_hits >= hits_needed
end

function futil.can_see_sky(pos, distance, trials, hits_needed)
	distance = distance or 20
	trials = trials or 11
	hits_needed = hits_needed or 5
	local num_hits = 0
	for _ = 1, trials do
		local ruv = futil.random_unit_vector()
		ruv.y = math.abs(ruv.y) -- look up, not at the ground
		local target = pos + (distance * ruv)
		if Raycast(pos, target, false, false)() then
			num_hits = num_hits + 1
			break
		end
	end
	return num_hits >= hits_needed
end

function futil.vector.is_valid_position(pos)
	if type(pos) ~= "table" then
		return false
	elseif not (type(pos.x) == "number" and type(pos.y) == "number" and type(pos.z) == "number") then
		return false
	else
		return futil.is_inside_world_bounds(vector.round(pos))
	end
end

local function hash_num(i)
	return string.format("%a", i)
end

function futil.vector.hash(pos)
	return hash_num(pos.x) .. hash_num(pos.y) .. hash_num(pos.z)
end
