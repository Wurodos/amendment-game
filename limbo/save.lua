local json = require "text.json"
local Saving = {}

local save = {}

function Saving.load()
    local file = io.open("limbo/save.json", "r")
    if not file then error("no save file") end
    local raw_json = file:read "*a"
    save = json.decode(raw_json)
end

function Saving.getSave()
    return save
end

function Saving.overwriteSave(new_save)
    save = new_save
    local raw_json = json.encode(save)

    local file = io.open("limbo/save.json", "w")
    if not file then error("no save file") end
    file:write(raw_json)
end

return Saving
