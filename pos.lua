

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

function futil.iterate_area(start, stop)
	local cur = table.copy(start)
	cur.x = cur.x - 1
	return function()
		if cur.z > stop.z then
			return
		end

		cur.x = cur.x + 1
		if cur.x > stop.x then
			cur.x = start.x
			cur.y = cur.y + 1
		end

		if cur.y > stop.y then
			cur.y = start.y
			cur.z = cur.z + 1
		end

		if cur.z <= stop.z then
			return vector.copy(cur)
		end
	end
end

function futil.iterate_volume(pos, radius)
	return futil.iterate_area(vector.subtract(pos, radius), vector.add(pos, radius))
end
