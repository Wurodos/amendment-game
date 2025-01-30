local Class = require "hump.class"
local json = require "text.json"

local all_trauma_text = {}

local Trauma = Class{
    init = function (self, name, effects)
        self.name = all_trauma_text[name].name
        self.img = love.graphics.newImage("torture/pain/img_"..name..".png")

        self.morale_tick = effects.morale_tick or 0
        self.copies = effects.copies or 1
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

function Trauma:draw(x, y)
    love.graphics.draw(self.img, x, y)
end

return Trauma