local Map = {}

local Tile = require "purgatory.tile"
local Entity = require "util.entity"
local Signal = require "hump.signal"

local Force = require "purgatory.force"

local img_party
local img_manual

local tile_pool = {}
local floor = {}
local floorSize = 11

local party = {map_pos = {x = 1, y = 1}}

local offset = 128
local camera_speed = 200
local camera_x = 0
local camera_y = 0

local is_movement_blocked = false
local is_force = false
local is_manual = false

local function addTileTo(i, j, tile)
    floor[i][j] = tile
    tile.x = offset * j
    tile.y = offset * i
end

function Map:init(param)
    party = {}
    tile_pool = {
        tile = Tile("tile"),
        purged = Tile("purged"),
        mash = Tile("mash"),
        exit = Tile("exit")
    }

    img_party = love.graphics.newImage("purgatory/party.png")
    img_manual = love.graphics.newImage("purgatory/manual_"..LANG..".png")
    party = {x=0,y=0,img=img_party, map_pos = {x = 1, y = 1}}
    Entity:new(party)

    if param.offset then offset = param.offset end
    if param.camera_speed then camera_speed = param.camera_speed end
    if param.team then party.team = param.team end
    if param._inventory then party.inventory = param._inventory end

    
    if param.is_tutorial then
        floor[1] = {}
        floor[1][1] = tile_pool.purged:clone()
            floor[1][1].x = offset * 1
            floor[1][1].y = offset
        
            floor[1][2] = tile_pool.tile:clone()
            floor[1][2].x = offset * 2
            floor[1][2].y = offset
        
            floor[1][3] = tile_pool.mash:clone()
            floor[1][3].x = offset * i
            floor[1][3].y = offset

            floor[1][4] = tile_pool.exit:clone()
            floor[1][4].x = offset * 4
            floor[1][4].y = offset
    end


    party.x = floor[1][1].x
    party.y = floor[1][1].y
    party.map_pos.x = 1
    party.map_pos.y = 1
    party.is_moving = false
end

function Map:purge()
    local purged_tile = tile_pool.purged:clone()
    purged_tile.x = floor[party.map_pos.y][party.map_pos.x].x
    purged_tile.y = floor[party.map_pos.y][party.map_pos.x].y
    floor[party.map_pos.y][party.map_pos.x] = purged_tile
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
        party.map_pos.x = party.map_pos.x + 1
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

    for i = 1, floorSize, 1 do
        for j = 1, floorSize, 1 do
            if floor[i] and floor[i][j] then
                love.graphics.draw(floor[i][j].img, camera_x +  floor[i][j].x, camera_y + floor[i][j].y)
            end
        end
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
    local current_tile = floor[party.map_pos.y][party.map_pos.x]
    if current_tile.name == "tile" then
        print("encounter tile") 
        -- Battle
        Signal.emit("battle")
    elseif floor[party.map_pos.y][party.map_pos.x].name == "mash" then
        Signal.emit("mash")
    elseif floor[party.map_pos.y][party.map_pos.x].name == "exit" then
        Map.generateFloor()
    end
end








--------------------------------------------------------------------------------------------------
----------------------------------------- MAP GENERATION -----------------------------------------
--------------------------------------------------------------------------------------------------

-- Basic algorithm
-- Start from center (size/2, size/2)
-- Create a pool of adjacents
-- Pick orthoganal direction
-- Generate random (size / 4 to size / 2) tiles in that dir
-- At each tile, there's 15% (-1% each time it happens) chance for branch, in which case pick perpendicular and add to queue
-- Repeat those 2 steps until all 4 orthoganal are resolved (w/ branches)




local branch_chance = 15

local function go(i, j, i_dt, j_dt, tilesLeft)
    -- out of bounds check
    if i > floorSize or j > floorSize or i == 0 or j == 0 then return end
    if tilesLeft == 0 then return end

    -- add tile
    if floor[i][j] == nil then
        addTileTo(i, j, tile_pool.tile:clone())
    end
    -- branch?

    -- keep going in direction
    go(i+i_dt, j+j_dt, i_dt, j_dt, tilesLeft - 1)
end

function Map.generateFloor()
    floor = {}
    branch_chance = 15

    for i = 1, floorSize, 1 do floor[i] = {} end
    local center = math.floor(floorSize / 2) + 1

    addTileTo(center, center, tile_pool.purged:clone())

    go(center + 1, center, 1, 0, math.random(center / 2, center))
    go(center - 1, center, -1, 0,math.random(center / 2, center))
    go(center, center + 1, 0, 1, math.random(center / 2, center))
    go(center, center - 1, 0, -1, math.random(center / 2, center))

    party.map_pos.x, party.map_pos.y = center, center
end



--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------


return Map