local Chaos = {}
local math = require "math"

function Chaos.contains(array, find)
    local has = false
    for _, value in ipairs(array) do
        if value == find then
            has = true
            break
        end
    end
    return has
end

function Chaos.pickRandom(table)
    return table[math.random(1, #table)]
end

return Chaos