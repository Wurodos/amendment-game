local Map = {}

local Tile = require "purgatory.tile"
local Entity = require "util.entity"
local Signal = require "hump.signal"

local Force = require "purgatory.force"

local img_party
local img_manual

local tile_pool = {}
local mask = {}

local party = {}

local offset = 128
local camera_speed = 200
local camera_x = 0
local camera_y = 0

local is_movement_blocked = false
local is_force = false
local is_manual = false

function Map:init(param)
    tile_pool = {
        tile = Tile("tile"),
        purged = Tile("purged"),
        mash = Tile("mash"),
        exit = Tile("exit")
    }

    img_party = love.graphics.newImage("purgatory/party.png")
    img_manual = love.graphics.newImage("purgatory/manual_"..LANG..".png")
    party = {x=0,y=0,img=img_party, tile_no = 1}
    Entity:new(party)

    if param.offset then offset = param.offset end
    if param.camera_speed then camera_speed = param.camera_speed end
    if param.team then party.team = param.team end
    if param._inventory then party.inventory = param._inventory end

    if param.is_tutorial then
        mask[1] = tile_pool.purged:clone()
            mask[1].x = offset * 1
            mask[1].y = offset
        
            mask[2] = tile_pool.tile:clone()
            mask[2].x = offset * 2
            mask[2].y = offset
        
        mask[3] = tile_pool.mash:clone()
        mask[3].x = offset * i
        mask[3].y = offset

        mask[4] = tile_pool.exit:clone()
        mask[4].x = offset * 4
        mask[4].y = offset
    end


    party.x = mask[party.tile_no].x
    party.y = mask[party.tile_no].y
    party.map_pos = 1
    party.is_moving = false
end

function Map:purge()
    local purged_tile = tile_pool.purged:clone()
    purged_tile.x = mask[party.map_pos].x
    purged_tile.y = mask[party.map_pos].y
    mask[party.map_pos] = purged_tile
end

function Map:returnToMap()
end

function Map:update(dt)
    if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
        camera_y = camera_y + dt*camera_speed end
    if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
        camera_y = camera_y - dt*camera_speed end
    if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
        camera_x = camera_x + dt*camera_speed end
    if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
        camera_x = camera_x - dt*camera_speed end
    Entity:update(dt)
    if is_force then
        for _, slave in ipairs(party.team.boys) do
            slave:update(dt)
        end
    end
end

function Map:keypressed(key)
    if party.is_moving then return end

    -- For now just moves party 1 step forward
    if key == "rshift" and not is_movement_blocked then
        party.is_moving = true
        party.map_pos = party.map_pos + 1
        Entity:move(party, {x=party.x+offset,y=party.y},300, function ()
            party.is_moving = false
            Map:encounter()
        end)
    -- party screen
    elseif key == "lctrl" then
        is_force = not is_force
        Force.init(party.team, party.inventory)
    elseif key == "q" then
        is_manual = not is_manual
    end

    if is_force then Force.keypressed(key) end
end

function Map:draw()

    for _, tile in ipairs(mask) do
        love.graphics.draw(tile.img, camera_x +  tile.x, camera_y + tile.y)
    end

    Entity:draw(camera_x, camera_y)
    if is_force then
        Force.draw()
    end

    if is_manual then
        love.graphics.draw(img_manual)
    end
end

function Map:blockMovement()
    is_movement_blocked = true
end

function Map:unblockMovement()
    is_movement_blocked = false
end

function Map:encounter()
    if mask[party.map_pos].name == "tile" then
        print("encounter tile")
        
        -- Battle
        Signal.emit("battle")
    elseif mask[party.map_pos].name == "mash" then
        Signal.emit("mash")
    elseif mask[party.map_pos].name == "exit" then
        Map.generateFloor()
    end
end




-- Basic algorithm
--
--
--

local floor = {}

function Map.generateFloor()
    
end


return Map