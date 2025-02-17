local Class = require "hump.class"
local json = require "text.json"

local Misc = require "util.misc"

local Text = require "text.text"

local all_trauma_text = {}

local Trauma = Class{
    init = function (self, name, severity, effects)
        self.universal_name = name
        self.name = all_trauma_text[name].name
        self.desc = all_trauma_text[name].desc
        self.x = 0
        self.y = 0

        self.img = love.graphics.newImage("torture/pain/img_"..name..".png")
        self.size = self.img:getWidth()

        self.severity = severity

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

    -- RED are dangerous and will lead to downfall in a few turns
    -- GREEN are mildly inconvenient and usually fuck up the victim's ability to fight 
    -- YELLOW are in the middle: can take down the team if too many of them and offer some utility

    TRAUMA_POOL = {
        -- a lot of bullets
        swisscheese = Trauma("swisscheese", 'r', {morale_tick = 20}),
        -- bite
        bitten = Trauma("bitten", 'y', {morale_tick = 7}),
        -- same trauma
        salt = Trauma("salt", 'y', {morale_tick = 5, copies = 3}),
        -- TODO change TRINKET order to 'Clean the Spores' that will remove it
        spore = Trauma("spore", 'g', {override_trinket = function (slave)
            slave:removeTrauma("spore")
        end}),
        -- a little morale drop w/ stacking enabled
        pain = Trauma("pain", 'g', {morale_tick = 2, copies = 3}),
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
        Text.setFont "readable"
        Text.draw(self.name, x - self.size, y + self.size, {limit=3*self.size})
        Text.draw(self.desc, x - self.size, y + self.size*1.5, {limit=3*self.size})
        Text.setFont "big"
    end
end

return Trauma