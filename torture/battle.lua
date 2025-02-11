local Battle = {}

local Text = require "text.text"
local Splash = require "torture.bits.splash"

local Item = require "torture.item.item"

local bg_image
local img_manual
local img_order

local good_team = {}
local inventory = {}
local bad_team = {}

local rewards = {}

local team_offset_x = 0
local team_offset_x_target = 150
local team_offset_y = 60
local intro_speed = 100

local victory_padding = 50

-- Fields: item, sender
local orders = {}
local current_order = {}

local waiting_for_dudes = 0

-- flags

local is_intro = false
local is_tutorial = false
local is_manual_open = false
local is_ordering = false
local is_targeting = false
local is_ready = false
local is_enemy = false
local is_won = false

local pos_order = {
    {x = 250, y = 100},
    {x = 150, y = 300},
    {x = 450, y = 300},
}
local resize_order = 0.7

local text_targeting = "placeholder"
local text_enemy_turn = "xoxo"
local text_your_turn = "oxox"
local text_victory = "llll"

local doAfterWin

function Battle:init(good, bad, afterWin, param)

    is_intro = true
    team_offset_x = 0
    -- Signal.register("animation_over_deferred", Battle.enemyTurn)

    bg_image = love.graphics.newImage("torture/bg.png")
    img_manual = love.graphics.newImage("torture/manual_"..LANG..".png")
    img_order = love.graphics.newImage("torture/bits/img_order.png")

    text_targeting = Text.get "TARGETING"
    text_enemy_turn = Text.get "ENEMY_TURN"
    text_your_turn = Text.get "YOUR_TURN"
    text_victory = Text.get "VICTORY"

    waiting_for_dudes = 0

    good_team = good
    bad_team = bad
    doAfterWin = afterWin
    
    is_ordering = false
    is_targeting = false
    is_ready = false
    is_enemy = false
    is_won = false

    if param == nil then return end
    
    if param.is_tutorial then is_tutorial = true
    else is_tutorial = false end
    inventory = param._inventory or {}
    
end


------------------------------------------------------------
-- A small animation of both teams approaching each other---
-- Should be easy? ----------------------------------------- 
------------------------------------------------------------

function Battle.intro()
    
end

------------------------------------------------

function Battle:update(dt)
    if is_intro then
        team_offset_x = team_offset_x + intro_speed*dt
        if team_offset_x >= team_offset_x_target then
            is_intro = false
        end
    end
    for _, slave in ipairs(good_team.boys) do
        slave:update(dt)
    end
    for _, slave in ipairs(bad_team.boys) do
        slave:update(dt)
    end
    Splash.update(dt)
end


function Battle:draw()
    -- Background
    love.graphics.setColor(0.8, 0.8, 0.8)
    love.graphics.draw(bg_image)
    love.graphics.setColor(1,1,1)

    -- Order connections
    if is_ready then
        for _, slave in ipairs(good_team.boys) do
            local order = slave.pending_order
            if order and order.victim then
                if order.victim.boys then
                    Splash.teamTarget(order.sender.x + team_offset_x + 64, order.sender.y + team_offset_y + 128)
                elseif order.sender ~= order.victim then
                    Splash.connectSlaves(
                    order.sender.x + team_offset_x + 64, order.sender.y + team_offset_y + 128,
                    order.victim.x + WINDOW_WIDTH - team_offset_x - 64, order.victim.y + team_offset_y + 128)
                else Splash.chooseSelf(order.sender.x + team_offset_x + 64, order.sender.y + team_offset_y + 128) end
            end
        end
        
    end

    -- Good team
    good_team:draw(team_offset_x, team_offset_y)
    -- Bad team
    bad_team:draw(WINDOW_WIDTH - team_offset_x, team_offset_y)


    -- Turn reminder
    if not is_won then
        if is_enemy then
            Text.draw(text_enemy_turn, 0, 50)
        else
            Text.draw(text_your_turn, 0, 50)
        end
    end

    -- Manual
    if is_manual_open then love.graphics.draw(img_manual) end

    -- Orders 
    if is_ordering then
        -- Veil
        love.graphics.setColor(0,0,0,0.5)
        love.graphics.rectangle("fill",0,0,WINDOW_WIDTH,WINDOW_HEIGHT)
        love.graphics.setColor(1,1,1,1)

        -- Order blocks
        
        for i, order in ipairs(orders) do
            if i > 1 then love.graphics.setColor(0.6, 0.6, 0.6) end
            love.graphics.draw(img_order, pos_order[i].x, pos_order[i].y, 0, resize_order, resize_order)
            Text.setFont("readable")
            Text.draw(order.item.name, pos_order[i].x + 60, pos_order[i].y + 10, {limit = 150, is_outlined = false})
            Text.setFont("medium")
            Text.draw(order.item.desc, pos_order[i].x, pos_order[i].y + 100, {limit = 280, is_outlined = false})
        end
        Text.setFont("medium")
    end

    if is_targeting then
        Text.draw(text_targeting..current_order.item.name, 0, 100)
    end


    -- Victory screen
    if is_won then
        love.graphics.setColor(0.7,0.7,0.7,0.7)
        love.graphics.rectangle("fill", victory_padding, victory_padding,
            WINDOW_WIDTH - 2*victory_padding, WINDOW_HEIGHT - 2*victory_padding)
        love.graphics.setColor(1,1,1,1)

        Text.draw(text_victory, 0, victory_padding*2)

        -- TODO Rewards

        for i, item in ipairs(rewards) do
            item:drawInBox(100*i, 300)
            Text.draw(i, 100*i, 300, {limit = 100})
        end

    end

end


function Battle:keypressed(key)
    if is_enemy then return end
    if is_won then
        if key >= '1' and key <= '9' then Battle.pickReward(key)
        elseif key == "return" then doAfterWin() end
        return
    end
    if key == "q" then is_manual_open = not is_manual_open
    elseif key == "u" and not is_ordering then Battle.startOrder(good_team.boys[1])
    elseif key == "h" and not is_ordering then Battle.startOrder(good_team.boys[2])
    elseif key == "b" and not is_ordering then Battle.startOrder(good_team.boys[3])
    elseif key == "a" and is_ordering then Battle.switchOrder(2)
    elseif key == "d" and is_ordering then Battle.switchOrder(3)
    elseif key == "s" and is_ordering then Battle.chooseTarget()
    elseif key == "o" and is_targeting then Battle.executeOrder(bad_team.boys[1])
    elseif key == "k" and is_targeting then Battle.executeOrder(bad_team.boys[2])
    elseif key == "m" and is_targeting then Battle.executeOrder(bad_team.boys[3])
    elseif key == "space" and is_ready and not is_targeting then Battle.confirmOrder()
    end
end

function Battle.startOrder(dude)
    if dude == nil then return end

    orders[1] = {sender = dude, item = dude.weapon}
    orders[2] = {sender = dude, item = dude.hat}
    orders[3] = {sender = dude, item = dude.trinket}
    is_ordering = true
    is_targeting = false
    
end

function Battle.chooseTarget()
    current_order = orders[1]
    current_order.sender.pending_order = current_order
    is_ordering = false
    is_targeting = true
    if current_order.item.target == Item.SINGLE then
        return
    elseif current_order.item.target == Item.TARGET.SELF then
        Battle.executeOrder(current_order.sender)
    elseif current_order.item.target == Item.TARGET.OWNTEAM then
        Battle.executeOrder(good_team)
    end
end

function Battle.executeOrder(victim)
    print("execute")
    current_order.victim = victim
    is_targeting = false
    is_ready = true
end

function Battle.confirmOrder()
    for _, slave in ipairs(good_team.boys) do
        if slave.pending_order then
            waiting_for_dudes = waiting_for_dudes + 1
            slave.pending_order.item.order(slave.pending_order.sender, slave.pending_order.victim)
            slave.pending_order = nil
        end
    end
    is_ready = false

end

-- 2 left
-- 3 right
function Battle.switchOrder(to)
    local temp = orders[1]
    orders[1] = orders[to]
    orders[to] = temp
end

function Battle.enemyTurn()
    print("enemy turn")
    bad_team:upkeep()
    if bad_team.morale <= 0 then return end
    
    is_enemy = true
    waiting_for_dudes = #bad_team.boys
    for _, bad in ipairs(bad_team.boys) do
        bad:onStartTurn(bad_team, good_team)
    end
end

function Battle.dudeDone()
    waiting_for_dudes = waiting_for_dudes - 1
    print("dude done. "..waiting_for_dudes.." left")
    if waiting_for_dudes == 0 then
        print("not waiting for dudes")
        if is_enemy then
            good_team:upkeep()
            is_enemy = false
        else
            Battle.enemyTurn()
        end
        
    end
end

function Battle.playerWin()
    if is_won then return end
    
    is_won = true


    if is_tutorial then rewards = {ITEM_POOL.Fang:clone()}
        return
    end


    for _, enemy in ipairs(bad_team.boys) do
        for _, item in ipairs(enemy:drop()) do
            print(item.name)
            rewards[#rewards+1] = item
        end
    end
end

function Battle.pickReward(num)
    print("picked reward "..num)
    num = tonumber(num)
    if rewards[num] then
        print(rewards[num].name)
        inventory[#inventory+1] = rewards[num]
        table.remove(rewards, num)
    end

end

return Battle