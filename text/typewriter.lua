local str = require "string"
local utf8 = require "utf8"

local tw = {}

local fulltext = ""
local text = ""

local time = 0
local delay = 0.1
local char_n = 0
local char_id = 1

local is_active = false

function tw.type(new_text, new_delay)
    fulltext = new_text
    char_n = #new_text
    char_id = 1

    text = ""

    if new_delay then delay = new_delay end

    is_active = true
end

function tw.update(dt)
    if not is_active then return end

    time = time + dt
    if time > delay then
        text = str.sub(fulltext, 1, utf8.offset(fulltext, char_id) - 1)
        char_id = char_id + 1
        time = 0
        if #text == char_n then
            is_active = false
        end
    end
end

function tw.fastforward()
    text = fulltext
    is_active = false
end

function tw.hasFinished()
    return not is_active
end

function tw.draw(x, y, limit, align)
    love.graphics.setColor(0,0,0)
    love.graphics.printf(text, x+2, y-2, limit, align)
    love.graphics.setColor(1,1,1)
    love.graphics.printf(text, x, y, limit, align)
end

return tw