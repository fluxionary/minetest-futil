futil.string = {}

function futil.string.truncate(s, max_length, suffix)
	suffix = suffix or "..."

	if s:len() > max_length then
		return s:sub(1, max_length - suffix:len()) .. suffix
	else
		return s
	end
end

function futil.string.lc_cmp(a, b)
	return a:lower() < b:lower()
end

function futil.string.startswith(s, start, start_i, end_i)
	return s:sub(start_i or 0, end_i or #s):sub(1, #start) == start
end
