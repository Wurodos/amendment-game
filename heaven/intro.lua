local Test = {}

-- map gen test
local Map = require "purgatory.map"
local map_debug = false


local Gamestate = require "hump.gamestate"
local Tutorial = require "heaven.tutorial"

local text = require "text.text"
local tw = require "text.typewriter"

local Chaos = require "util.chaos"

local tw_delay = 0.07
local dialogue_id = 1

local is_over = false

local img_chervonozorz, img_polotsk

local static_y = 0

function Test:init()
    img_chervonozorz = love.graphics.newImage("heaven/chervonozorz.png")
    img_polotsk = love.graphics.newImage("heaven/polotsk.png")
    dialogue_id = 1
    love.window.setTitle("HEAVEN")
    tw.type(text.get "GREETING", 0.07)

    if map_debug then
        Map:init({})
        Map.generateFloor()
    end

end

function Test:update(dt)
    if map_debug then Map:update(dt) end
    tw.update(dt)
    static_y = static_y + 100*dt
    if static_y > WINDOW_HEIGHT then
        static_y = 0
    end
end

function Test:mousereleased()
    if tw.hasFinished() then
        if is_over then
            Gamestate.switch(Tutorial)
            return
        end
        print("continue...")
        if dialogue_id == 7 then
            tw_delay = 0.2
            is_over = true
        end
        tw.type(text.get ("HEAVEN_"..dialogue_id), tw_delay)
        dialogue_id = dialogue_id + 1
    else
        -- skip
        tw.fastforward()
    end
end

function Test:draw()

    if map_debug then Map:draw() end
    
    

    text.setFont "big"
    love.graphics.setColor(1, 1, 1)

    if dialogue_id == 3 then
        love.graphics.draw(img_chervonozorz, 200, 200, 0, 0.75, 0.75)
    elseif dialogue_id == 4 then
        love.graphics.draw(img_polotsk, 200, 200, 0, 0.75, 0.75)
    end

    tw.draw(0, 50, WINDOW_WIDTH, "center")

    love.graphics.setColor(0.5, 0.5, 0.5)
    if tw.hasFinished() then
        text.setFont "medium"
        love.graphics.printf(text.get "CLICK_REMINDER", 0, WINDOW_HEIGHT - 50, WINDOW_WIDTH, "center")
    end
    
    -- static

    for i = 1, 10, 1 do
        local y = static_y+Chaos.pseudo(-32,32)*i
        if y > WINDOW_HEIGHT then
            y = y - WINDOW_HEIGHT
        elseif y < 0 then
            y = y + WINDOW_HEIGHT
        end
        love.graphics.rectangle("fill", 0, y, WINDOW_WIDTH, 4)
    end
end

return Test