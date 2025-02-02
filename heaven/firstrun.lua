-- The taste of a "real" game
-- There will be a small "cutscene" where it looks like a battle but isn't
--
-- Able to open party screen and manual while in MAP mode
-- Party screen is quite limited: only able to (un)equip items
-- 2nd floor is randomly generated (hopefully I can make an epic camera pan)
-- Reptile there would be unbeatable and will cause a loss

local Firstrun = {}

local Signal = require "hump.signal"

local Map = require "purgatory.map"
local Battle = require "torture.battle"
local ThirtySeven = require "heaven.37"

local is_map = false
local is_battle = false

local player_team = {}
local inventory = {}



function Firstrun:init()
    Map:returnToMap()
end

function Firstrun:enter(_, team, _inventory)
    player_team = team
    inventory = _inventory
    for _, item in ipairs(inventory) do
        print(item.name)
    end

    Signal.register("battle", function ()
        is_battle = true
        is_map = false
    end)

    is_map = true
    is_battle = false
end

function Firstrun:update(dt)
    if is_map then Map:update(dt) end
    if is_battle then Battle:update(dt) end
end

function Firstrun:draw()
    if is_map then Map:draw() end
    if is_battle then Battle:draw() end
end

function Firstrun:keypressed(key)
    if is_map then Map:keypressed(key) end
end

return Firstrun