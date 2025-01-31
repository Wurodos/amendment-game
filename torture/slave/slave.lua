local Class = require "hump.class"
local Signal = require "hump.signal"
local Chaos = require "util.chaos"

local Splash = require "torture.bits.splash"
local Battle = require "torture.battle"

local Trauma = require "torture.pain.trauma"

local Slave = Class{
    init = function (self, weapon, hat, trinket, resize, img_path)
        self.x = 0
        self.y = 0

        self.resize = resize or 1
        self.offset =  64 * (self.resize - 1)
        
        self.weapon = weapon or ITEM_POOL.Fist:clone()
        self.hat = hat or ITEM_POOL.ClearHead:clone()
        self.trinket = trinket or ITEM_POOL.EmptyHand:clone()

        self.emotional = {}
        self.all_animators = {}
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
    for i, trauma in ipairs(self.emotional) do
        trauma:draw(self.x+x+52*(i-1)*self.resize, self.y+y)
    end
    for _, animator in ipairs(self.all_animators) do
        animator:draw(self.x+x+self.offset, self.y+y)
    end
end

function Slave:update(dt)
    for _, animator in ipairs(self.all_animators) do
        animator:update(dt)
    end
    for _, trauma in ipairs(self.emotional) do
        trauma:update(dt)
    end
end

function Slave:addTrauma(trauma)
    local is_duplicate = false
    if trauma.copies == 1 then
        for _, tr in ipairs(self.emotional) do
            if trauma.name == tr.name then
                is_duplicate = true
                break
            end
        end
    end

    if is_duplicate then
        if trauma.copies == 1 then
            self:addTrauma(TRAUMA_POOL.salt:clone())
        end
    else 
        self.emotional[#self.emotional+1] = trauma
    end
    return is_duplicate
end

function Slave:getItems()
    return {self.weapon,self.hat,self.trinket}
end

function Slave:animCut(do_after)
    self.all_animators[#self.all_animators+1] =
    Splash.Animator(ANIMATION_POOL.cut, function ()
        do_after()
        table.remove(self.all_animators, 1)
        Battle.dudeDone()
    end)
end

function Slave:animShoot(do_after)
    self.all_animators[#self.all_animators+1] =
    Splash.Animator(ANIMATION_POOL.shoot, function ()
        do_after()
        table.remove(self.all_animators, 1)
        Battle.dudeDone()
    end)
end

return Slave