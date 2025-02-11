local Class = require "hump.class"
local Gamestate = require "hump.gamestate"

local Battle = require "torture.battle"
local Slave = require "torture.slave.slave"
local Text = require "text.text"

local Void = require "limbo.void"

local slave_offset = 120
local morale_length = 220
local morale_label = nil

local health_color = {0.36, 0.72, 0.36, 1.0}

local Team = Class{
    init = function (self, boys, maxmorale, is_player_team)
        self.boys = {}
        for _, boy in ipairs(boys) do
            self:add(boy)
        end
        self.maxmorale = maxmorale or 100
        self.morale = self.maxmorale
        self.ratio = self.morale / self.maxmorale
        self.is_player_team = is_player_team or false
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

function Team:upkeep()
    for _, slave in ipairs(self.boys) do
        for _, trauma in ipairs(slave.emotional) do
            if trauma.morale_tick then
                print("morale tick "..trauma.morale_tick)
                self:changeMorale(-trauma.morale_tick)
            end
        end
    end
end

function Team:changeMorale(delta)
    -- TODO animation
    self.morale = self.morale + delta
    self.ratio = self.morale / self.maxmorale

    if self.morale <= 0 then
        self.ratio = 0
        if self.is_player_team then
            Gamestate.switch(Void)
        else
            Battle.playerWin()
        end
    end
end


return Team