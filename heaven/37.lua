-- "cutscene" before the "real" game
-- masherov is talking

local Father = {}

local Text = require "text.text"
local tw = require "text.typewriter"

local Splash = require "torture.bits.splash"

local dialogue_id = 2
local sub_id = 1

local lines = {}
local sublines = {}

local right_team = {}
local left_team = {}

local team_offset_x = 0
local team_offset_x_target = 120
local intro_speed = 50

local team_offset_y = 60

local animator
local bg_anim = {}
local tw_delay = 0.07

local function advanceDialogue()
    print(dialogue_id)
    if dialogue_id == 8 and sub_id < 5 then
        tw.type(sublines[sub_id])
        sub_id = sub_id + 1
    else
        tw.type(lines[dialogue_id])
        dialogue_id = dialogue_id + 1
    end
end

local goBack

function Father.init(_left_team, _right_team, _goBack)
    print(dialogue_id)
    left_team = _left_team
    right_team = _right_team
    goBack = _goBack
    bg_anim = {
        frames = Splash.loadFrames("bg_static", 5, "heaven/"),
        fps = 10
    }

    lines = Text.get_batch "LINES_MASHEROV_INTRO"
    
    -- conditional dialogue example
    local is_healed = true
    for _, slave in ipairs(left_team.boys) do
        if #slave.emotional > 0 then
            is_healed = false
            break
        end
    end
    -- If party is healed get HEALED
    if is_healed then
        sublines = Text.get_batch "LINES_MASHEROV_INTRO_HEALED"
    else -- Otherwise NOHEAL
        sublines = Text.get_batch "LINES_MASHEROV_INTRO_NOHEAL"
    end
    

    tw.type(lines[1], tw_delay)

    animator = Splash.Animator(bg_anim)
end

function Father.update(dt)
    if team_offset_x < team_offset_x_target then
        team_offset_x = team_offset_x + dt*intro_speed
    end
    tw.update(dt)
    animator:update(dt)
end

function Father.draw()
    love.graphics.setColor(0.5, 0.5, 0.5)
    animator:draw()
    love.graphics.setColor(1, 1, 1)

    -- Good team
    left_team:draw(team_offset_x, team_offset_y)
    -- Bad team
    right_team:draw(WINDOW_WIDTH - team_offset_x, team_offset_y)

    -- Dialogue
    love.graphics.setColor(0.2,0.2,0.2)
    love.graphics.rectangle("fill", WINDOW_WIDTH*0.5-80, 450, WINDOW_WIDTH * 0.5 + 80, 130)
    love.graphics.setColor(1,1,1)
    tw.draw(WINDOW_WIDTH * 0.5 - 30, WINDOW_HEIGHT - 150, WINDOW_WIDTH * 0.5 - 20, "right")
end

function Father.mousereleased()
    if tw.hasFinished() then
        if dialogue_id < 11 then
            advanceDialogue()
        else
            -- Go back to map
            goBack()
        end
    else
        -- skip
        tw.fastforward()
    end
end

return Father