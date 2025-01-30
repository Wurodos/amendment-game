local Entity = {}

local Signal = require "hump.signal"
local Vector = require "hump.vector"

local all = {}
local all_animation = {}


function Entity:new(thing)
    all[#all+1] = thing
end

function Entity:move(thing, to, speed, f)
    local v1, v2 = Vector.new(thing.x, thing.y), Vector.new(to.x, to.y)
    all_animation[#all_animation+1] = {thing=thing,to=to,speed=speed,
    dir=(v2 - v1):normalized()}
    Signal.register("entity_over", f)
    print((v2 - v1):normalized():unpack())
end

function Entity:update(dt)
    for _, anim in ipairs(all_animation) do
        anim.thing.x = anim.thing.x + anim.speed*anim.dir.x*dt
        anim.thing.y = anim.thing.y + anim.speed*anim.dir.y*dt

        if math.abs(anim.thing.x + anim.thing.y - anim.to.x - anim.to.y) < 5 then
            Signal.emit("entity_over")
            Signal.remove("entity_over")
            table.remove(all_animation, _)
        end
    end
end

function Entity:draw(x, y)
    for _, thing in ipairs(all) do
        love.graphics.draw(thing.img, x + thing.x, y + thing.y)
    end
end

return Entity