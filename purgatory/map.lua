local Map = {}

local Tile = require "purgatory.tile"
local Entity = require "util.entity"
local Signal = require "hump.signal"

local img_party

local tile_pool = {}
local mask = {}

local party = {}

local offset = 128
local camera_speed = 200
local camera_x = 0
local camera_y = 0

local is_movement_blocked = false

function Map:init(param)
    tile_pool = {
        tile = Tile("tile"),
        exit = Tile("exit")
    }

    img_party = love.graphics.newImage("purgatory/party.png")
    party = {x=0,y=0,img=img_party, tile_no = 1}
    Entity:new(party)

    if param.offset then offset = param.offset end
    if param.camera_speed then camera_speed = param.camera_speed end

    if param.is_tutorial then
        for i = 1, 3, 1 do
            mask[i] = tile_pool.tile:clone()
            mask[i].x = offset * i
            mask[i].y = offset
        end
        mask[4] = tile_pool.exit:clone()
        mask[4].x = offset * 4
        mask[4].y = offset
    end


    party.x = mask[party.tile_no].x
    party.y = mask[party.tile_no].y
    party.map_pos = 1
    party.is_moving = false
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
end

function Map:keypressed(key)
    -- For now just moves party 1 step forward
    if key == "rshift" and not party.is_moving and not is_movement_blocked then
        party.is_moving = true
        party.map_pos = party.map_pos + 1
        Entity:move(party, {x=party.x+offset,y=party.y},300, function ()
            Map:encounter()
        end)
    end
end

function Map:draw()
    for i, tile in ipairs(mask) do
        love.graphics.draw(tile.img, camera_x +  tile.x, camera_y + tile.y)
    end
    

    Entity:draw(camera_x, camera_y)
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
    end
end

return Map