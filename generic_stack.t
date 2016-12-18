local C = terralib.includec "stdlib.h"

-- Stack is a Lua function that accepts a Terra type T and returns a
-- constructor for Terra stacks
function Stack(T)
    -- A bounded stack of elements of type T
    local struct Stack {
        elems : &T
        cap : uint
        sp : uint
    }

    -- The following are methods
    -- Stack:method(...) is syntactic sugar for
    -- Stack.methods.method(self : &Stack, ...)

    terra Stack:push(val : T)
        if self.sp == self.cap then return false end
        self.elems[self.sp] = val
        self.sp = self.sp + 1
        return true
    end

    terra Stack:pop(buf : &T)
        if self.sp == 0 then return false end
        self.sp = self.sp - 1
        @buf = self.elems[self.sp]
        return true
    end

    terra Stack:free()
        C.free(self.elems)
    end

    -- The constructor is an anonymous Terra function
    return terra (n : uint)
        var elems = [&T](C.malloc(n * sizeof(T)))
        return Stack { elems, n, 0 }
    end
end

terra test()
    var i, n = 1.f, 10u
    -- Call Lua function Stack with type T = float and immediately apply the
    -- returned constructor
    var s = [Stack(float)](n)
    -- s:method(...) is syntactic sugar for
    -- Stack.methods.method(&s, ...)
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
