futil.random = {}

function futil.random.choice(t, random)
	random = random or math.random
	return t[random(#t)]
end

function futil.random.weighted_choice(t, random)
	random = random or math.random
	local elements, weights = {}, {}
	local i = 1
	for element, weight in pairs(t) do
		elements[i] = element
		weights[i] = weight
		i = i + 1
	end
	local breaks = futil.list(futil.iterators.accumulate(weights))
	local value = random() * breaks[#breaks]
	i = futil.bisect.right(breaks, value)
	return elements[i]
end
