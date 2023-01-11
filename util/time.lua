local idiv = futil.math.idiv

function futil.seconds_to_interval(time)
	local s, m, h, d

	time, s = idiv(time, 60)
	time, m = idiv(time, 60)
	time, h = idiv(time, 24)
	time, d = idiv(time, 365)

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

function futil.format_utc(timestamp)
	return os.date("!%Y-%m-%dT%TZ", timestamp)
end
