local Firstrun = {}

local Map = require "purgatory.map"

local is_map = false
local is_battle = false

local player_team = {}

function Firstrun:init()
    Map:returnToMap()
end

function Firstrun:enter(_, team)
    player_team = team
    for i, dude in ipairs(player_team.boys) do
        print(i)
    end
end

function Firstrun:update(dt)
    Map:update(dt)
end

function Firstrun:draw()
    love.graphics.print("Welcome to your first run!")
    Map:draw()
end

function Firstrun:keypressed(key)
    if is_map then Map:keypressed(key) end
end

return Firstrun