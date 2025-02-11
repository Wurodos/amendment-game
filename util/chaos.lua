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

local sample = 1000

local pseudo = {}
local ptr

function Chaos.init()
    ptr = 1
    for i = 1, sample, 1 do
        pseudo[#pseudo+1] = math.random(1, 10000)
    end
end

function Chaos.pseudo(from, to)
    local r = (pseudo[ptr] % (to - from + 1)) + from
    ptr = ptr + 1
    if ptr > sample then
        ptr = 1
    end
    return r
end

function Chaos.pickRandom(table)
    return table[math.random(1, #table)]
end

return Chaos