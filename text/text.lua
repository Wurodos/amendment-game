---@diagnostic disable: undefined-global
local json = require "text.json"
local io = require "io"

local tt = {}

local all_text = {}
local all_font = {}

function tt.init()
    all_font.big = love.graphics.newFont("text/mainfont.ttf", 32) 
    all_font.medium = love.graphics.newFont("text/mainfont.ttf", 16)
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

function tt.get(text)
    return all_text[text]
end

return tt