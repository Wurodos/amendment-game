local Battle = {}

local Text = require "text.text"
local Splash = require "torture.bits.splash"

local bg_image
local img_manual
local img_order

local good_team = {}
local bad_team = {}
local team_offset_x = 150
local team_offset_y = 60

-- Fields: item, sender
local orders = {}
local current_order = {}

local is_manual_open = false
local is_ordering = false
local is_targeting = false
local is_ready = false
local is_enemy = false

local pos_order = {
    {x = 250, y = 100},
    {x = 150, y = 300},
    {x = 450, y = 300},
}
local resize_order = 0.7

local text_targeting = "placeholder"

function Battle:init(good, bad)
    bg_image = love.graphics.newImage("torture/bg.png")
    img_manual = love.graphics.newImage("torture/manual_"..LANG..".png")
    img_order = love.graphics.newImage("torture/bits/img_order.png")

    text_targeting = Text.get "TARGETING"

    good_team = good
    bad_team = bad
    is_ordering = false
    is_targeting = false
    is_ready = false
end


function Battle:update(dt)
end


function Battle:draw()
    -- Background
    love.graphics.setColor(0.8, 0.8, 0.8)
    love.graphics.draw(bg_image)
    love.graphics.setColor(1,1,1)

    if is_ready then
        for _, slave in ipairs(good_team.boys) do
            local order = slave.pending_order
            if order and order.victim then
                Splash.connectSlaves(
                order.sender.x + team_offset_x + 64, order.sender.y + team_offset_y + 128,
                order.victim.x + WINDOW_WIDTH - team_offset_x - 64, order.victim.y + team_offset_y + 128)
            end
        end
        
    end

    -- Good team
    good_team:draw(team_offset_x, team_offset_y)
    -- Bad team
    bad_team:draw(WINDOW_WIDTH - team_offset_x, team_offset_y)

    -- Manual
    if is_manual_open then love.graphics.draw(img_manual) end

    if is_ordering then
        -- Veil
        love.graphics.setColor(0,0,0,0.5)
        love.graphics.rectangle("fill",0,0,WINDOW_WIDTH,WINDOW_HEIGHT)
        love.graphics.setColor(1,1,1,1)

        -- Orders
        
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

   

end


function Battle:keypressed(key)
    if is_enemy then return end

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
    elseif key == "space" and is_ready then Battle.confirmOrder()
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
            slave.pending_order.item.order(slave.pending_order.sender, slave.pending_order.victim)
            slave.pending_order = nil
        end
    end

    is_ready = false
    Battle.enemyTurn()
end

-- 2 left
-- 3 right
function Battle.switchOrder(to)
    local temp = orders[1]
    orders[1] = orders[to]
    orders[to] = temp
end

function Battle.enemyTurn()
    is_enemy = true
end

return Battle