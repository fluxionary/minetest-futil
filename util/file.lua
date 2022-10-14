function futil.file_exists(path)
	local f = io.open(path, "r")
	if f then
		io.close(f)
		return true
	else
		return false
	end
end
