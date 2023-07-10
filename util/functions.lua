function futil.coalesce(...)
	for i = 1, #arg do
		local v = arg[i]
		if v ~= nil then
			return v
		end
	end
end
