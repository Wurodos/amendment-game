local Class = require "hump.class"
local Signal = require "hump.signal"
local Splash = require "torture.bits.splash"
local Misc = require "util.misc"
local json = require "text.json"
local Text = require "text.text"

local offsets = {
    w = {x = 100, y = 40},
    h = {x = 25, y = -60},
    t = {x = -30, y = 70}
}

local resize = 0.5


local all_item_text = {}

local Item = Class{
    init = function (self, id, type, name, order, target, extra)
        self.id = id
        self.type = type
        self.pos = offsets[self.type]
        if type == 't' then self.resize = resize/2 else self.resize = resize end

        self.name = all_item_text[name].name
        self.desc = all_item_text[name].desc
        if id > 0 then self.img = love.graphics.newImage("torture/item/img_"..name..".png") end
        self.order = order
        self.target = target
        if extra then
            self.onEquip = extra.onEquip
        end
    end,
    TARGET = {
        NOTARGET = -1,
        SELF   = 0,
        SINGLE = 1,
        OWNTEAM = 2
    }
}

function Item.initPool()

    local file = io.open("torture/item/text_item_"..LANG..".json", "r")
    if not file then error("no item text file") end
    local raw_json = file:read "*a"
    all_item_text = json.decode(raw_json)

    
    ITEM_POOL = {
        Fist = Item(-1, 'w', 'Fist',
        function (sender, victim)
            print("low dmg")
        end,Item.TARGET.SINGLE),

        ClearHead = Item(-1, 'h', 'ClearHead', function (sender, victim) 
            print("protect self")
            sender:animShield(function () Item.protect(sender, 1) end)
        end, Item.TARGET.SELF),

        EmptyHand = Item(-1, 't', 'EmptyHand',
        function (sender, victims) 
            print("restore morale")
            sender:animSun(function () Item.changeMorale(victims, 10) end)
        end, Item.TARGET.OWNTEAM),

        MagnetAccelerator = Item(1, 'w', 'MagnetAccelerator',
        function (sender, victim)
            print("magnet acceleration!!!!")
            victim:animShoot(function () Item.severeDMG(sender, victim) end)
        end, Item.TARGET.SINGLE),

        Cap = Item(2, 'h', 'Cap',
        function (sender, victim)
            print("cap order")
        end, Item.TARGET.SINGLE),


        Receiver = Item(3, 't', 'Receiver',
        function (sender, victim)
            print("receiver order")
        end, Item.TARGET.OWNTEAM),


        Fang = Item(4, 't', 'Fang',
        function (sender, victim)
            print("fang order") 
        end, Item.TARGET.SINGLE),


        Draniki = Item(5, 't', 'Draniki',
        function (sender, victim)
             Item.healAllYellow(sender)
             Item.oneTimeUse(sender, 't')
        end, Item.TARGET.SINGLE, 
        {onEquip = function (slave)
                if Item.healAllYellow(slave) then
                    Item.oneTimeUse(slave, 't')
                end
             end}),
    }



end


-- items are 256x256
-- requires resizing
function Item:draw(slave_x, slave_y, slave_s)
    local s = slave_s or 1
    if self.img then 
        love.graphics.draw(self.img, self.pos.x*s + slave_x , self.pos.y + slave_y, 0,
            s*self.resize, self.resize) 
    end
end

function Item:drawInBox(x,y)
    love.graphics.setColor(0.2,0.2,0.7,0.8)
    love.graphics.rectangle("fill", x, y, 128*resize, 128*resize)
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.img, x, y, 0, resize*0.5)
end

function Item:drawDisplay(x, y)
    --sprite
    love.graphics.draw(self.img, x, y, 0, resize)
    --name
    Text.draw(self.name, x - 25, y + 128, {limit = 150})
    --description
    Text.setFont("readable")
    Text.draw(self.desc, x - 50, y + 160, {limit = 300})
    Text.setFont("big")
    
end

function Item.severeDMG(sender, victim)
    victim:addTrauma(TRAUMA_POOL.swisscheese:clone())
end

function Item.protect(target, prot_class)
    print("protected!")
    if target.protection < prot_class then target.protection = prot_class end
end

function Item.changeMorale(team, delta)
    team:changeMorale(delta)
end

function Item.healAllYellow(victim)
    return Misc.filter_inplace(victim.emotional, function (trauma) return trauma.severity ~= 'y' end)
end

function Item.oneTimeUse(slave, item_type)
    if item_type == 'w' then
        slave:equip(ITEM_POOL.Fist:clone())
    elseif item_type == 'h' then
        slave:equip(ITEM_POOL.ClearHead:clone())
    elseif item_type == 't' then
        slave:equip(ITEM_POOL.EmptyHand:clone())
    end
end

return Item