local Class = require "hump.class"

local Slave = require "torture.slave.slave"

local Team = Class{
    init = function (self, boys)
        self.boys = boys
    end,
}

function Team:add(slave)
    self.boys[#self.boys+1] = slave
end

function Team:draw(x, y)
    for i, slave in ipairs(self.boys) do
        slave:draw(x, y)
    end
end


return Team