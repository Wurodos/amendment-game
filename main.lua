local Gamestate = require "hump.gamestate"
local Menu = require "boot.menu"
require "gooi"


function love.load()
    TT = require "text.text"
    STYLE = {}
    
    WINDOW_HEIGHT = love.graphics.getHeight()
    WINDOW_WIDTH = love.graphics.getWidth()
    TT.init()

    Gamestate.registerEvents()
    Gamestate.switch(Menu)
end

function love.update(dt)
end

function love.draw()
end