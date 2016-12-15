-- Lua code
local C = terralib.includec "stdio.h"

-- Terra code
terra hello()
    -- Terra code calling C code
    C.puts("Hello Terra!")
end

-- Lua code calling Terra code -> hello is JIT compiled
hello()
