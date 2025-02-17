-- Force screen
local Force = {}
local itemPages = {}

local padding = 60

local is_slave_ptr = false
local is_item_ptr = false

local slave_ptr = 1
local item_ptr = 1

local team
local inventory

function Force.init(_team, _inventory)
    team = _team
    inventory = _inventory
end

-- TODO. Make it possible to store more than 9 items through pages
function Force.refreshItemPages()
    
end

function Force.draw()
    love.graphics.setColor(0, 0, 0.5)
    love.graphics.rectangle("fill", padding, padding, WINDOW_WIDTH - 2*padding, WINDOW_HEIGHT - 2*padding)
    love.graphics.setColor(1,1,1)

    -- slaves
    for i, slave in ipairs(team.boys) do
        slave:draw(150*i, 0)
    end

    -- items
    for i, item in ipairs(inventory) do
        item:drawInBox((WINDOW_WIDTH - padding - 100 * (i%3 + 1)), padding + 10 + 80*math.floor((i-1) / 3))
    end

    -- slave ptr

    if is_slave_ptr then love.graphics.setColor(1, 1, 0) else love.graphics.setColor(0.5, 0.5, 0) end
    love.graphics.setLineWidth(4)
    love.graphics.rectangle("line", 150*slave_ptr + team.boys[slave_ptr].x, team.boys[slave_ptr].y, 128, 128)
    
    -- item ptr
    if is_item_ptr then love.graphics.setColor(1, 1, 0) else love.graphics.setColor(0.5, 0.5, 0) end
    if item_ptr > 0 then love.graphics.rectangle("line", WINDOW_WIDTH - padding - 100 * (item_ptr%3 + 1),
        padding + 10 + 80*math.floor((item_ptr-1) / 3), 64, 64) end


    love.graphics.setLineWidth(1)
    love.graphics.setColor(1,1,1)

    -- current item in bottom left

    if item_ptr > 0 then
        inventory[item_ptr]:drawDisplay(WINDOW_WIDTH *0.25 - padding , WINDOW_HEIGHT * 0.5)
    end


end

function Force.keypressed(key)
    if key == "i" then
        is_item_ptr = not is_item_ptr
    elseif key == "s" then
        is_slave_ptr = not is_slave_ptr
    elseif key == "." then
        if is_item_ptr then
            item_ptr = item_ptr - 1
            if item_ptr < 1 then item_ptr = #inventory end
        end
        if is_slave_ptr then
            slave_ptr = slave_ptr - 1
            if slave_ptr < 1 then slave_ptr = #team.boys end
        end
    elseif key == "," then
        if is_item_ptr and item_ptr > 0 then
            item_ptr = item_ptr + 1
            if item_ptr > #inventory then item_ptr = 1 end
        end
        if is_slave_ptr then
            slave_ptr = slave_ptr + 1
            if slave_ptr > #team.boys then slave_ptr = 1 end
        end
    elseif key == "tab" and item_ptr > 0 then
        local leftover = team.boys[slave_ptr]:equip(inventory[item_ptr])

        table.remove(inventory, item_ptr)

        if leftover.id > 0 then
            inventory[#inventory+1] = leftover
        end

        item_ptr = item_ptr - 1
        if item_ptr < 1 then item_ptr = #inventory end 
    end
end

return Force