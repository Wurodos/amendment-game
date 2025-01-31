local Firstrun = {}

local is_map = false
local is_battle = false

function Firstrun:init()
end

function Firstrun:update(dt)
    
end

function Firstrun:draw()
    love.graphics.print("Welcome to your first run!")
end

return Firstrun