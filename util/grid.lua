local Grid = {}

Grid.stuff = {}

function Grid.draw(x,y)
    for i, item in ipairs(Grid.stuff) do
        item:draw(x,y)
    end
end

return Grid