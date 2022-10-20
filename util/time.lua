local idiv = math.idiv

function futil.seconds_to_interval(time)
	local s = time % 60;
	time = idiv(time, 60)
	local m = time % 60;
	time = idiv(time, 60)
	local h = time % 24;
	time = idiv(time, 24)
	local d = time % 365;
	time = idiv(time, 365)

	if time ~= 0 then
		return ("%d years %d days %02d:%02d:%02d"):format(time, d, h, m, s)

	elseif d ~= 0 then
		return ("%d days %02d:%02d:%02d"):format(d, h, m, s)

	elseif h ~= 0 then
		return ("%02d:%02d:%02d"):format(h, m, s)

	elseif m ~= 0 then
		return ("%02d:%02d"):format(m, s)

	else
		return ("%d seconds"):format(s)
	end
end
