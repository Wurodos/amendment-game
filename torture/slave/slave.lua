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

        
        self.protection = self.PROT.NOPROT

        if img_path then self.img = love.graphics.newImage(img_path)
        else self.img = love.graphics.newImage("torture/slave/slave.png") end

        -- idle animation
        self.idle = Chaos.pseudo(0, 10) * self.resize
        self.idle_delta = 1
        self.timer = 0
    end,
    PROT = {
        NOPROT = 0,
        LIGHT = 1,
        MEDIUM = 2
    }
}

function Slave:draw(x, y)
    x = x - self.idle
    love.graphics.draw(self.img, self.x + x, self.y + y, 0, self.resize+self.idle*0.01, 1)

    for _, item in ipairs(self:getItems()) do
        item:draw(self.x+x,self.y+y,self.resize)
    end
    for i, trauma in ipairs(self.emotional) do
        trauma:draw(self.x+x+52*(i-1)*self.resize, self.y+y)
    end
    if self.all_animators[1] then
        self.all_animators[1]:draw(self.x+x+self.offset, self.y+y)
    end
end

local idle_delay = 0.05

function Slave:update(dt)
    self.timer = self.timer + dt
    if self.timer > idle_delay then
        self.idle = self.idle + self.idle_delta
        self.timer = self.timer - idle_delay
        if math.abs(self.idle) > 10 then self.idle_delta = self.idle_delta * -1 end
    end

    if self.all_animators[1] then
        self.all_animators[1]:update(dt)
    end
    for _, trauma in ipairs(self.emotional) do
        trauma:update(dt)
    end
end

function Slave:addTrauma(trauma)
    local duplicate_entries = 0
    for _, tr in ipairs(self.emotional) do
        if trauma.name == tr.name then
            duplicate_entries = duplicate_entries + 1
        end
    end

    if duplicate_entries < trauma.copies then
        self.emotional[#self.emotional+1] = trauma
    elseif trauma.name ~= TRAUMA_POOL.salt.name then
        self:addTrauma(TRAUMA_POOL.salt:clone())
    end
    
    return duplicate_entries < trauma.copies
end

function Slave:removeTrauma(name)
    for i, trauma in ipairs(self.emotional) do
        if trauma.universal_name == name then
            table.remove(self.emotional, i)
            return true
        end
    end
    return false
end

function Slave:equip(item)
    print("equipped "..item.name)
    local old_item = nil

    if item.type == "w" then
        old_item = self.weapon
        self.weapon = item
    elseif item.type == "h" then
        old_item = self.hat
        self.hat = item
    elseif item.type == "t" then
        old_item = self.trinket
        self.trinket = item
    end

    if item.onEquip then item.onEquip(self) end

    return old_item
end

function Slave:getItems()
    return {self.weapon,self.hat,self.trinket}
end


-- Dialogue System

function Slave:advanceDialogue()
    
end

function Slave:talk(allLines, do_after)
    
end



-- Attack animations

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

function Slave:animShield(do_after)
    self.all_animators[#self.all_animators+1] =
    Splash.Animator(ANIMATION_POOL.shield, function ()
        do_after()
        table.remove(self.all_animators, 1)
        Battle.dudeDone()
    end)
end

function Slave:animSun(do_after)
    self.all_animators[#self.all_animators+1] =
    Splash.Animator(ANIMATION_POOL.sun, function ()
        do_after()
        table.remove(self.all_animators, 1)
        Battle.dudeDone()
    end)
end

return Slave