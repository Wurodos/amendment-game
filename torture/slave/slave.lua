local Class = require "hump.class"

local Slave = Class{
    init = function (self, img_path)
        self.x = 0
        self.y = 0
        if img_path then self.img = love.graphics.newImage(img_path)
        else self.img = love.graphics.newImage("torture/slave/slave.png") end
    end,
}

function Slave:draw(x, y)
    love.graphics.draw(self.img, self.x + x, self.y + y)
end


return Slave