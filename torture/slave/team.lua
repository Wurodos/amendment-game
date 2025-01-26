local Class = require "hump.class"

local Slave = require "torture.slave.slave"
local Text = require "text.text"

local slave_offset = 120
local morale_length = 220
local morale_label = nil

local health_color = {0.36, 0.72, 0.36, 1.0}

local Team = Class{
    init = function (self, boys)
        self.boys = boys
        self.maxmorale = 100
        self.morale = 100
        self.ratio = self.morale / self.maxmorale
        if morale_label == nil then morale_label = Text.get "MORALE" end
    end,
}

function Team:add(slave)
    slave.y = (#self.boys+1)*slave_offset
    self.boys[#self.boys+1] = slave
end

function Team:draw(x, y)
    for _, slave in ipairs(self.boys) do
        slave:draw(x, y)
    end

    -- morale bar
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle("fill", x - 120, 50, morale_length, 50)
    love.graphics.setColor(health_color)
    love.graphics.rectangle("fill", x - 120, 50, self.ratio * morale_length, 50)
    love.graphics.setColor(1,1,1)
    Text.draw(morale_label, x-120, 15, {align="left"})
end


return Team