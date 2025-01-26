local Class = require "hump.class"

local Slave = Class{
    init = function (self, weapon, hat, trinket, resize, img_path)
        self.x = 0
        self.y = 0
        self.resize = resize or 1
        self.weapon = weapon or ITEM_POOL.Fist:clone()
        self.hat = hat or ITEM_POOL.ClearHead:clone()
        self.trinket = trinket or ITEM_POOL.EmptyHand:clone()
        self.pending_order = nil
        if img_path then self.img = love.graphics.newImage(img_path)
        else self.img = love.graphics.newImage("torture/slave/slave.png") end
    end,
}

function Slave:draw(x, y)
    love.graphics.draw(self.img, self.x + x, self.y + y, 0, self.resize, 1)
    for _, item in ipairs(self:getItems()) do
        item:draw(self.x+x,self.y+y,self.resize)
    end
end

function Slave:getItems()
    return {self.weapon,self.hat,self.trinket}
end


return Slave