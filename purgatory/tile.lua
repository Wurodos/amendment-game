local Class = require "hump.class"

local Tile = Class{
    init = function (self, name)
        self.name = name
        self.img = love.graphics.newImage("purgatory/bits/"..name..".png")
        self.x = 0
        self.y = 0
    end,
}

return Tile