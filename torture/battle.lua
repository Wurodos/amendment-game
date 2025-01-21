local Battle = {}

local bg_image
local img_manual

local good_team = {}
local bad_team = {}

local is_manual_open = false

function Battle:init(good, bad)
    bg_image = love.graphics.newImage("torture/bg.png")
    img_manual = love.graphics.newImage("torture/manual.png")
    good_team = good
    bad_team = bad
end


function Battle:update(dt)
end


function Battle:draw()
    -- Background
    love.graphics.draw(bg_image)

    -- Good team
    good_team:draw(150, 100)
    -- Bad team
    bad_team:draw(WINDOW_WIDTH - 300, 100)

    -- Manual
    if is_manual_open then
        love.graphics.draw(img_manual)
    end

end


function Battle:keypressed(key)
    if key == "q" then
        is_manual_open = not is_manual_open
    end
end


return Battle