local Void = {}

local Saving = require "limbo.save"

local tw = require "text.typewriter"

local new_save = {}

-- Void is used if you lose a run

function Void:init()

    gooi.components = {}
    local w,h = WINDOW_WIDTH, WINDOW_HEIGHT
    local a,b = 360, 200

    new_save = Saving.getSave()
    local btn_end = gooi.newButton({text = "...-  ..  -  -..-"}):bg(component.colors.blue)
    :onRelease(Void.endAll)

    local pGrid = gooi.newPanel({x = w/2 - a/2, y = h/2 - b/2, w = a, h = b, layout = "grid 1x1"})
    pGrid:add(btn_end)
end

function Void:update(dt)
    gooi.update(dt)
end

function Void:draw()
    gooi.draw()
end

function Void:mousereleased(x, y, button) gooi.released() end
function Void:mousepressed(x, y, button)  gooi.pressed() end

function Void.endAll()
    print("it's over")
    new_save.run = new_save.run + 1
    new_save.failed = new_save.failed + 1
    Saving.overwriteSave(new_save)
    love.event.quit()
end

return Void