local Splash = {}

local Signal = require "hump.signal"

local ellipse_width = 50

local function loadFrames(name, n)
    local frames = {}
    for i = 1, n, 1 do
        frames[i] = love.graphics.newImage("torture/bits/anim_"..name.."_"..i..".png")
    end
    return frames
end

function Splash.connectSlaves(x1, y1, x2, y2)
    love.graphics.setColor(0.7,0,0)
    love.graphics.setLineWidth(10)

    love.graphics.line(x1 + ellipse_width,y1,x2 - ellipse_width,y2)
    love.graphics.ellipse("line", x1, y1, ellipse_width, 30)
    love.graphics.ellipse("line", x2, y2, ellipse_width, 30)
    love.graphics.setColor(1,1,1)
end



local animation_queue = {}
local current_frame
local is_animating = false
local spf = 0.15

local delta = 0

function Splash.init()
    current_frame = 1
    is_animating = false
    ANIMATION_POOL = {
        cut = {
            frames = loadFrames("cut", 4),
            fps = 5
        }
    }
end

function Splash.addAnimation(animation)
    animation_queue[#animation_queue+1] = animation
    is_animating = true
end

function Splash.update(dt)
    delta = delta + dt
    if delta > spf then
        delta = 0
        if not is_animating then return end
        current_frame = current_frame + 1
        if #animation_queue[1].frames < current_frame then
            table.remove(animation_queue, 1)
            current_frame = 1
            if #animation_queue == 0 then
                is_animating = false
                Signal.emit("animation_over")
            end
        end
    end
    
end

function Splash.draw(x, y)
    if is_animating then
        love.graphics.draw(animation_queue[1].frames[current_frame], x, y) 
    end
end




return Splash