local Signal = require "hump.signal"
local Class = require "hump.class"

local Splash = {}

Splash.Animator = Class{
    init = function (self, animation, doAfter)
        self.current_frame = 1
        self.delta = 0
        self.spf = 1/animation.fps
        self.doAfter = doAfter
        self.frames = animation.frames
    end,
    update = function (self, dt)
        self.delta = self.delta + dt
        if self.delta > self.spf then
            self.delta = 0
            self.current_frame = self.current_frame + 1
            if self.current_frame > #self.frames then
                self.doAfter()
            end
        end
    end,
    draw = function (self, x, y)
        love.graphics.draw(self.frames[self.current_frame], x, y)
    end
}

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

function Splash.new()
    return setmetatable({}, Splash)
end

function Splash.init()
    current_frame = 1
    is_animating = false
    ANIMATION_POOL = {
        cut = {
            frames = loadFrames("cut", 4),
            fps = 5
        },
        shoot = {
            frames = loadFrames("shoot", 4),
            fps = 10
        }
    }
end

function Splash.addAnimation(animation, doAfter)
    animation_queue[#animation_queue+1] = {anim = animation, doAfter = doAfter}
    is_animating = true
end

function Splash.update(dt)
    delta = delta + dt
    if delta > spf then
        delta = 0
        if not is_animating then return end
        current_frame = current_frame + 1
        if #animation_queue[1].anim.frames < current_frame then
            animation_queue[1].doAfter()
            table.remove(animation_queue, 1)
            current_frame = 1
            if #animation_queue == 0 then
                is_animating = false
                print("all animation is over")
                --Signal.emit("animation_over")
                --Signal.emit("animation_over_deferred")
                --
                --Signal.clear("animation_over")
                --Signal.clear("animation_over_deferred")
            end
        end
    end
    
end

function Splash.draw(x, y)
    if is_animating then
        love.graphics.draw(animation_queue[1].anim.frames[current_frame], x, y) 
    end
end




return Splash