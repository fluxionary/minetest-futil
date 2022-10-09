function futil.wait(n)
    local wait_until = minetest.get_us_time() + n
    while minetest.get_us_time() < wait_until do end
end
