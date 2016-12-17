local C = terralib.includec "stdlib.h"

-- A bounded stack of integers
struct Stack {
    elems : &int
    cap : uint
    sp : uint
}

-- The following are methods
-- Stack:method(...) is syntactic sugar for
-- Stack.methods.method(self : &Stack, ...)

terra Stack:push(val : int)
    if self.sp == self.cap then return false end
    self.elems[self.sp] = val
    self.sp = self.sp + 1
    return true
end

terra Stack:pop(buf : &int)
    if self.sp == 0 then return false end
    self.sp = self.sp - 1
    @buf = self.elems[self.sp]
    return true
end

terra Stack:init(n : uint)
    self.elems = [&int](C.malloc(n * sizeof(int)))
    self.cap = n
    self.sp = 0
end

terra Stack:free()
    C.free(self.elems)
end

terra test()
    var i, n = 1, 10u
    var s : Stack
    -- s:method(...) is syntactic sugar for
    -- Stack.methods.method(&s, ...)
    s:init(n)
    defer s:free()
    while s:push(i) do
        i = i + 1
    end
    while s:pop(&i) do
        if i ~= n then return false end
        n = n - 1
    end
    return true
end

assert(test(), "Stack test failed")
