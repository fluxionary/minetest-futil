local f = string.format

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

function futil.random.choice(t, random)
	assert(#t > 0, "cannot get choice from an empty table")
	random = random or math.random
	return t[random(#t)]
end

-- https://stats.stackexchange.com/questions/569647/
function futil.random.sample(t, k, random)
	assert(k <= #t, f("cannot sample %i items from a set of size %i", k, #t))
	random = random or math.random
	local sample = {}
	for i = 1, k do
		sample[i] = t[k]
	end
	for j = k + 1, #t do
		if random() < k / j then
			sample[random(1, k)] = t[j]
		end
	end

	return sample
end
