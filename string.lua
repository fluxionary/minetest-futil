
function futil.truncate(s, max_length)
	if s:len() > max_length then
		return s:sub(1, max_length - 3) .. "..."
	else
		return s
	end
end
