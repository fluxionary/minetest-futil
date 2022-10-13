function futil.file_exists(name, ie)
	local io = io
	if ie then
		io = ie.io
	end

	local f = io.open(name, "r")
	if f ~= nil then
		io.close(f)
		return true
	else
		return false
	end
end
