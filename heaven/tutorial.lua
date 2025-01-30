local Tutorial = {}

local Gamestate = require "hump.gamestate"
local Signal = require "hump.signal"

local Map = require "purgatory.map"
local text = require "text.text"
local tw = require "text.typewriter"

local Battle = require "torture.battle"
local Team = require "torture.slave.team"
local Slave = require "torture.slave.slave"
local Enemy = require "torture.enemy.enemy"

local is_map = false
local is_battle = false

local expedition_force = nil
local ambush_force = nil

local dialogue_id = 1
local tw_delay = 1

local function advance_dialogue()
    -- wait until battle starts
    if dialogue_id > 2 and not is_battle then return end

    tw.type(text.get ("TUTORIAL_"..dialogue_id), tw_delay)
    if dialogue_id == 2 then Map:unblockMovement() end
    dialogue_id = dialogue_id + 1
end

function Tutorial:init()
    is_map = true
    tw_delay = 0.04
    
    expedition_force = Team({})
    expedition_force:add(Slave(ITEM_POOL.MagnetAccelerator:clone()))
    expedition_force:add(Slave(ITEM_POOL.MagnetAccelerator:clone()))

    ambush_force = Team({})
    ambush_force:add(Enemy.Chomper(nil, nil, nil, -1))
    ambush_force:add(Enemy.Chomper(nil, nil, nil, -1))

    Map:init({is_tutorial = true})
    Map:blockMovement()
    Signal.register("battle", function ()
        is_battle = true
        is_map = false
        Battle:init(expedition_force, ambush_force)
        advance_dialogue()
    end)

    tw.type(text.get "TUTORIAL_1", tw_delay)
    dialogue_id = 2
end

function Tutorial:update(dt)
    if is_map then Map:update(dt) end
    if is_battle then Battle:update(dt) end
    tw.update(dt)
end

function Tutorial:keypressed(key)
    if is_map then Map:keypressed(key) end
    if is_battle then
        if key == 'q' then
            if dialogue_id < 6 then return
            elseif dialogue_id == 6 or dialogue_id == 9 then advance_dialogue()
            elseif dialogue_id == 7 or dialogue_id == 8 then return end
            Battle:keypressed(key)
        elseif dialogue_id > 11 then
            if dialogue_id == 12 and (key == "u" or key == "h") then advance_dialogue()
            elseif dialogue_id == 13 and key == "s" then advance_dialogue()
            elseif dialogue_id == 14 and (key == "space") then advance_dialogue()
            elseif dialogue_id > 15 and dialogue_id < 21 then return end
            Battle:keypressed(key)
        end
    end
end

function Tutorial:mousereleased()
    if tw.hasFinished() then
        if dialogue_id ~= 6 and dialogue_id ~= 9 and dialogue_id ~= 12
        and dialogue_id ~= 13 and dialogue_id ~= 14 and dialogue_id ~= 21 then
            advance_dialogue() end
        else
        -- skip
        tw.fastforward()
    end
end

function Tutorial:draw()
    love.graphics.setColor(1,1,1)
    if is_map then Map:draw() end
    if is_battle then Battle:draw() end

    love.graphics.setColor(0.3,0.3,0.3)
    love.graphics.rectangle("fill", 0, 450, WINDOW_WIDTH, 130)
    love.graphics.setColor(1,1,1)
    text.setFont("big")
    tw.draw(50, WINDOW_HEIGHT - 150, WINDOW_WIDTH - 100, "left")
end


return Tutorial

