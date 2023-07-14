-- box definition below node boxes: https://github.com/minetest/minetest/blob/master/doc/lua_api.md#node-boxes

local x1 = 1
local y1 = 2
local z1 = 3
local x2 = 4
local y2 = 5
local z2 = 6

function futil.boxes_intersect(box1, box2)
	return not (
		(box1[x2] < box2[x1] or box2[x2] < box1[x1])
		or (box1[y2] < box2[y1] or box2[y2] < box1[y1])
		or (box1[z2] < box2[z1] or box2[z2] < box1[z1])
	)
end

function futil.box_offset(box, number_or_vector)
	if type(number_or_vector) == "number" then
		return {
			box[1] + number_or_vector,
			box[2] + number_or_vector,
			box[3] + number_or_vector,
			box[4] + number_or_vector,
			box[5] + number_or_vector,
			box[6] + number_or_vector,
		}
	else
		return {
			box[1] + number_or_vector.x,
			box[2] + number_or_vector.y,
			box[3] + number_or_vector.z,
			box[4] + number_or_vector.x,
			box[5] + number_or_vector.y,
			box[6] + number_or_vector.z,
		}
	end
end

function futil.is_box(box)
	if type(box) == "table" and #box == 6 then
		for _, x in ipairs(box) do
			if type(x) ~= "number" then
				return false
			end
		end
		return box[1] <= box[4] and box[2] <= box[5] and box[3] <= box[6]
	end
	return false
end

function futil.is_boxes(boxes)
	if type(boxes) == "table" and #boxes > 0 then
		for _, box in ipairs(boxes) do
			if not futil.is_box(box) then
				return false
			end
		end
		return true
	end
	return false
end
