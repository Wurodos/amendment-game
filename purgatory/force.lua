-- Force screen
local Force = {}

local team
local inventory

function Force.init(_team, _inventory)
    team = _team
    inventory = _inventory
end

function Force.draw()
    love.graphics.setColor(0, 0, 0.5)
    love.graphics.rectangle("fill", 60, 60, WINDOW_WIDTH - 120, WINDOW_HEIGHT - 120)
    love.graphics.setColor(1,1,1)

    for i, slave in ipairs(team.boys) do
        slave:draw(150*i, 0)
    end
end

function Force.keypressed(key)
end

return Force