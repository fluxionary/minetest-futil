function futil.is_nil(v)
	return v == nil
end

function futil.is_boolean(v)
	return v == true or v == false
end

function futil.is_number(v)
	return type(v) == "number"
end

function futil.is_string(v)
	return type(v) == "string"
end

function futil.is_userdata(v)
	return type(v) == "userdata"
end

function futil.is_function(v)
	return type(v) == "function"
end

function futil.is_thread(v)
	return type(v) == "thread"
end

function futil.is_table(v)
	return type(v) == "table"
end
