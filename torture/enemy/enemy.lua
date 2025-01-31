local Class = require "hump.class"
local Slave = require "torture.slave.slave"
local Battle = require "torture.battle"

local Chaos = require "util.chaos"

local Enemy = {}

-- COMMON ENEMIES

Enemy.Chomper = Class{ __includes = Slave,
    init = function (self, weapon, hat, trinket, resize)
        Slave.init(self, weapon, hat, trinket, resize)
        self.img = love.graphics.newImage("torture/enemy/chomper.png")
    end,
}

function Enemy.Chomper:onStartTurn(own_team, enemy_team)
    -- Bites random dude
    local target = Chaos.pickRandom(enemy_team.boys)
    target:animCut(function ()
        target:addTrauma(TRAUMA_POOL.bitten:clone())
    end)
end

return Enemy