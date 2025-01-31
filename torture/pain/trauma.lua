local Class = require "hump.class"
local json = require "text.json"

local Misc = require "util.misc"

local Text = require "text.text"

local all_trauma_text = {}

local Trauma = Class{
    init = function (self, name, effects)
        self.name = all_trauma_text[name].name
        self.desc = all_trauma_text[name].desc
        self.x = 0
        self.y = 0

        self.img = love.graphics.newImage("torture/pain/img_"..name..".png")
        self.size = self.img:getWidth()

        self.morale_tick = effects.morale_tick or 0
        self.copies = effects.copies or 1
        
        self.is_under_mouse = false
    end
}

function Trauma.initPool()
    local file = io.open("torture/pain/text_trauma_"..LANG..".json", "r")
    if not file then error("no item text file") end
    local raw_json = file:read "*a"
    all_trauma_text = json.decode(raw_json)



    TRAUMA_POOL = {
        swisscheese = Trauma("swisscheese", {morale_tick = 20}),
        bitten = Trauma("bitten", {morale_tick = 5}),
        salt = Trauma("salt", {morale_tick = 5, copies = 3}) 
    }
end

function Trauma:update(dt)
    local mouse_x, mouse_y = love.mouse.getPosition()
    self.is_under_mouse = Misc.isInsideRect(mouse_x, mouse_y,
        self.x, self.y, self.size, self.size)
end

function Trauma:draw(x, y)
    self.x = x
    self.y = y
    love.graphics.draw(self.img, x, y)
    if self.is_under_mouse then
        Text.draw(self.name, x - self.size, y + self.size, {limit=3*self.size})
    end
end

return Trauma