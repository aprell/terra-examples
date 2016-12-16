-- generic_sort is a Lua function that accepts a Terra type T and returns two
-- Terra functions that deal with elements of type T
--> Terra types are first-class Lua values
function generic_sort(T)
    local terra swap(a : &T, b : &T)
        @a, @b = @b, @a
    end

    local terra is_sorted(values : &T, len : int)
        for i = 1, len do
            if values[i-1] > values[i] then
                return false
            end
        end
        return true
    end

    local terra sort(values : &T, len : int)
        for i = 1, len do
            for j = i, 0, -1 do
                if values[j-1] > values[j] then
                    swap(&values[j-1], &values[j])
                end
            end
        end
    end

    -- Return a table containing two Terra functions
    return {sort, is_sorted}
end

-- len is a Lua function that inspects a Terra array
local function len(a)
    -- Terra objects are first-class Lua values (tables)
    return a.type.N
end

terra test()
    var a = arrayof(float, 3, 1, 4, 1, 5, 9, 2, 6, 5)
    -- Use [] to insert the result of a Lua expression into Terra code
    var l = [len(a)]
    -- The table returned by generic_sort is automatically unpacked
    var sort, is_sorted = [generic_sort(float)]
    sort(a, l)
    return is_sorted(a, l)
end

assert(test(), "Sorting failed")
