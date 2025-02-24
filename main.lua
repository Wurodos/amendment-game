local Gamestate = require "hump.gamestate"
local Menu = require "boot.menu"
local Splash = require "torture.bits.splash"
local Saving = require "limbo.save"
local Chaos = require "util.chaos"

local math = require "math"
require "gooi"




function love.load()
    local TT = require "text.text"

    Chaos.init()
    math.randomseed(100)

    STYLE = {}
    
    WINDOW_HEIGHT = love.graphics.getHeight()
    WINDOW_WIDTH = love.graphics.getWidth()
    
    TT.init()
    Splash.init()
    Saving.load()

    Gamestate.registerEvents()
    Gamestate.switch(Menu)
end

function love.update(dt)
end

function love.draw()
end