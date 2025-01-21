local json = require "text.json"
local saving = {}

local save = {}

function saving.load()
    local file
    file = io.open("limbo/save.json", "r")
    if not file then error("no text file") end
    local raw_json = file:read "*a"
    save = json.decode(raw_json)
end

function saving.getSave()
    return save
end

return saving
