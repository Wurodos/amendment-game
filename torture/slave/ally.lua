local Class = require "hump.class"

local Slave = require "torture.slave.slave"

local Ally = Class{__includes = Slave,
    init = function (self, ...)
        Slave.init(self, ...)
    end
}

function Ally:makeMasherov()
    self.img = love.graphics.newImage("torture/slave/img_masherov.png")
end

return Ally
