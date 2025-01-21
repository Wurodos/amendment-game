---@diagnostic disable: undefined-global
local Gamestate = require "hump.gamestate"
local Test = require "heaven.intro"
local text = require "text.text"


local Menu = {}

function Menu:init()
    love.window.setTitle("BOOTABLE DEVICE")

    local w,h = WINDOW_WIDTH, WINDOW_HEIGHT
    local a,b = 360, 200

    text.setFont("big")


    local btn_play_ru = gooi.newButton({text = "Русский"}):bg(component.colors.green)
    :onRelease(function ()
        LANG = "ru"
        text.getFile("ru")
        Gamestate.switch(Test)
    end)
    local btn_play_en = gooi.newButton({text = "English"}):bg(component.colors.green)
    :onRelease(function ()
        LANG = "en"
        text.getFile("en")
        Gamestate.switch(Test)
    end)

    local pGrid = gooi.newPanel({x = w/2 - a/2, y = h/2 - b/2, w = a, h = b, layout = "grid 2x1"})
    pGrid:add(btn_play_en)
    pGrid:add(btn_play_ru)
end

function Menu:update(dt)
    gooi.update(dt)
end

function Menu:draw()
    gooi.draw()
end

function Menu:mousereleased(x, y, button) gooi.released() end
function Menu:mousepressed(x, y, button)  gooi.pressed() end

return Menu
