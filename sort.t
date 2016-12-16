terra swap(a : &int, b : &int)
    @a, @b = @b, @a
end

-- Insertion sort
terra sort(values : &int, len : int)
    for i = 1, len do
        for j = i, 0, -1 do
            if values[j-1] > values[j] then
                swap(&values[j-1], &values[j])
            end
        end
    end
end

terra is_sorted(values : &int, len : int)
    for i = 1, len do
        if values[i-1] > values[i] then
            return false
        end
    end
    return true
end

-- len is a Lua function that inspects a Terra array
local function len(a)
    -- Terra objects are first-class Lua values (tables)
    return a.type.N
end

terra test()
    var a = array(3, 1, 4, 1, 5, 9, 2, 6, 5)
    -- Use [] to insert the result of a Lua expression into Terra code
    var l = [len(a)]
    sort(a, l)
    return is_sorted(a, l)
end

assert(test(), "Sorting failed")
