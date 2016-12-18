local C = terralib.includec "stdio.h"

require "stack"

-- compile is a Lua function that generates Terra code for evaluating an RPN
-- expression
function compile(code)
    local function codegen(stack)
        local binops = {
            -- Terra expressions (`...) are first-class Lua values
            ["+"] = function (a, b) return `a + b end,
            ["-"] = function (a, b) return `a - b end,
            ["*"] = function (a, b) return `a * b end,
            ["/"] = function (a, b) return `a / b end,
        }
        local stmts = terralib.newlist()
        for token in code:gmatch "%S+" do
            -- Terra statements (quote ... end) are first-class Lua values
            if token:match "[+%-*/]" then
                stmts:insert(quote
                    var a : int, b : int
                    stack:pop(&b)
                    stack:pop(&a)
                    stack:push([binops[token](a, b)])
                end)
            elseif token == "=" then
                stmts:insert(quote
                    var a : int
                    stack:pop(&a)
                    return a
                end)
            elseif token == "." then
                stmts:insert(quote
                    var a : int
                    stack:pop(&a)
                    C.printf("%d\n", a)
                end)
            else
                -- Interpret as number
                stmts:insert(quote
                    stack:push([tonumber(token)])
                end)
            end
        end
        return stmts
    end

    return terra (n : uint)
        var stack : Stack
        stack:init(n)
        defer stack:free()
        [codegen(stack)]
    end
end

local code = compile "1 2 + 3 4 + * ="
assert(code(100) == 21, "Calculation failed")
