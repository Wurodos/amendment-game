---@diagnostic disable: undefined-global
local Gamestate = require "hump.gamestate"
local Test = require "heaven.intro"
local Item = require "torture.item.item"
local Trauma = require "torture.pain.trauma"
local Enemy = require "torture.enemy.enemy"
local text = require "text.text"


-- testing
local Splash = require "torture.bits.splash"
local Timer = require "hump.timer"
local Signal = require "hump.signal"
local anim_frames = {}
local cur_frame = 0

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
        Item.initPool()
        Trauma.initPool()
        Gamestate.switch(Test)
    end)
    local btn_play_en = gooi.newButton({text = "English"}):bg(component.colors.green)
    :onRelease(function ()
        LANG = "en"
        text.getFile("en")
        Item.initPool()
        Trauma.initPool()
        Gamestate.switch(Test)
    end)

    local pGrid = gooi.newPanel({x = w/2 - a/2, y = h/2 - b/2, w = a, h = b, layout = "grid 2x1"})
    pGrid:add(btn_play_en)
    pGrid:add(btn_play_ru)


    --anim_frames[0] = love.graphics.newImage("torture/bits/anim_cut_0.png")
    --anim_frames[1] = love.graphics.newImage("torture/bits/anim_cut_1.png")
    --anim_frames[2] = love.graphics.newImage("torture/bits/anim_cut_2.png")
    --anim_frames[3] = love.graphics.newImage("torture/bits/anim_cut_3.png")
    --Timer.every(0.1, function ()
    --    cur_frame = cur_frame + 1
    --    if cur_frame > 3 then cur_frame = 0 end
    --end)

    --Splash.addAnimation(ANIMATION_POOL.cut)
    --Splash.addAnimation(ANIMATION_POOL.cut)
    --Splash.addAnimation(ANIMATION_POOL.cut)
    --Signal.register("animation_over", function () print("animation over!") end)

end

function Menu:update(dt)
    --Timer.update(dt)
    --Splash.update(dt)
    gooi.update(dt)
end

function Menu:draw()

    -- testing

    --love.graphics.setLineWidth(10)
    --love.graphics.setColor(0.7,0,0)
    --love.graphics.line(300, 300, 700, 300)
    --love.graphics.setColor(1,1,1)
    --Splash.connectSlaves(200, 300, 700, 300)
    --love.graphics.draw(anim_frames[cur_frame], 100, 100)

    --Splash.draw(100, 100)
    gooi.draw()
end

function Menu:mousereleased(x, y, button) gooi.released() end
function Menu:mousepressed(x, y, button)  gooi.pressed() end

return Menu
