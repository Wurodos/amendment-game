local Test = {}


local Gamestate = require "hump.gamestate"
local Tutorial = require "heaven.tutorial"

local text = require "text.text"
local tw = require "text.typewriter"

local tw_delay = 0.07
local dialogue_id = 1

local is_over = false

function Test:init()
    dialogue_id = 1
    love.window.setTitle("HEAVEN")
    tw.type(text.get "GREETING", 0.07)
end

function Test:update(dt)
    tw.update(dt)
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
    text.setFont "big"
    love.graphics.setColor(1, 1, 1)
    tw.draw(0, 50, WINDOW_WIDTH, "center")

    if tw.hasFinished() then
        text.setFont "medium"
        love.graphics.setColor(0.5, 0.5, 0.5)
        love.graphics.printf(text.get "CLICK_REMINDER", 0, WINDOW_HEIGHT - 50, WINDOW_WIDTH, "center")
    end
end

return Test