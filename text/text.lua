---@diagnostic disable: undefined-global
local json = require "text.json"
local io = require "io"

local tt = {}

local all_text = {}
local all_font = {}

function tt.init()
    all_font.big = love.graphics.newFont("text/mainfont.ttf", 32)
    all_font.readable = love.graphics.newFont("text/mainfont.ttf", 24)
    all_font.medium = love.graphics.newFont("text/mainfont.ttf", 16)
    all_font.common = love.graphics.newFont("text/mainfont.ttf", 12)
    all_font.small = love.graphics.newFont("text/mainfont.ttf", 8)
    LANG = ""
end

function tt.setFont(fontId)
    STYLE.font = all_font[fontId]
    love.graphics.setFont(all_font[fontId])
    gooi.setStyle(STYLE)
end

function tt.getFile(language)
    local file
    file = io.open("text/text_"..language..".json", "r")
    if not file then error("no text file") end
    local raw_json = file:read "*a"
    all_text = json.decode(raw_json)
end

function tt.get(text_id)
    return all_text[text_id]
end

function tt.draw(text, x, y, param)
    local limit = WINDOW_WIDTH
    local align = "center"
    local is_outlined = true
    if param then
        limit = param.limit or WINDOW_WIDTH
        align = param.align or "center"
        if param.is_outlined ~= nil then is_outlined = param.is_outlined end
    end

    if is_outlined then
        love.graphics.setColor(0,0,0)
        love.graphics.printf(text, x+2, y-2, limit, align)
        love.graphics.setColor(1,1,1)
    end
    love.graphics.printf(text, x, y, limit, align)
end

return tt