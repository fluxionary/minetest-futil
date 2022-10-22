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
