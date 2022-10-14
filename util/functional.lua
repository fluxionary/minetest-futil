local functional = {}

function functional.noop()
	-- the NOTHING function does nothing.
end

function functional.identity(x)
	return x
end

function functional.izip(...)
	local is = {...}
	if #is == 0 then
		return functional.noop
	end

	return function()
		local t = {}
		for i in table.iterate(is) do
			local v = i()
			if v ~= nil then
				table.insert(t, v)

			else
				return
			end
		end

		return t
	end
end

function functional.zip(...)
	local is = {}
	for t in table.iterate({...}) do
		table.insert(is, table.iterate(t))
	end
	return functional.izip(unpack(is))
end

function functional.imap(func, ...)
	local zipper = functional.izip(...)
	return function()
		local args = zipper()
		if args then
			return func(unpack(args))
		end
	end
end

function functional.map(func, ...)
	local zipper = functional.zip(...)
	return function()
		local args = zipper()
		if args then
			return func(unpack(args))
		end
	end
end

function functional.apply(func, t)
	for k, v in pairs(t) do
		t[k] = func(v)
	end
end

function functional.reduce(func, t, initial)
	local i = table.iterate(t)
	if not initial then
		initial = i()
	end
	local next = i()
	while next do
		initial = func(initial, next)
		next = i()
	end
	return initial
end

function functional.partial(func, ...)
	local args = {...}
	return function(...)
		return func(unpack(args), ...)
	end
end

function functional.compose(a, b)
	return function(...)
		return a(b(...))
	end
end

function functional.ifilter(func, i)
	local v
	return function()
		v = i()
		while v ~= nil and not func(v) do
			v = i()
		end
		return v
	end
end

function functional.filter(func, t)
	return functional.ifilter(func, table.iterate(t))
end

futil.functional = functional
