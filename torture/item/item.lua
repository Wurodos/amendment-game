local Class = require "hump.class"
local json = require "text.json"

local offsets = {
    w = {x = 100, y = 40},
    h = {x = 25, y = -60},
    t = {x = 15, y = 100}
}

local resize = 0.5


local all_item_text = {}

local Item = Class{
    init = function (self, id, type, name, order)
        self.id = id
        self.type = type
        self.pos = offsets[self.type]

        self.name = all_item_text[name].name
        self.desc = all_item_text[name].desc
        if id > 0 then self.img = love.graphics.newImage("torture/item/img_"..name..".png") end
        self.order = order
    end,
}

function Item.initPool()

    local file = io.open("torture/item/text_item_"..LANG..".json", "r")
    if not file then error("no item text file") end
    local raw_json = file:read "*a"
    all_item_text = json.decode(raw_json)

    
    ITEM_POOL = {
        Fist = Item(-1, 'w', 'Fist', function (sender, victim) print("low dmg") end),
        ClearHead = Item(-1, 'h', 'ClearHead', function (sender, victim) print("protect self") end),
        EmptyHand = Item(-1, 't', 'EmptyHand', function (sender, victim) print("restore morale") end),
        MagnetAccelerator = Item(1, 'w', 'MagnetAccelerator', function (sender, victim) print("shoot") end),
        Cap = Item(2, 'h', 'Cap', function (sender, victim) print("cap order") end),
        Receiver = Item(3, 't', 'Receiver', function (sender, victim) print("receiver order") end),
    }



end


-- items are 256x256
-- requires resizing
function Item:draw(slave_x, slave_y, slave_s)
    local s = slave_s or 1
    if self.img then love.graphics.draw(self.img, self.pos.x*s + slave_x , self.pos.y*s + slave_y, 0, s*resize) end
end


return Item