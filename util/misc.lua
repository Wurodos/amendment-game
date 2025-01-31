local Misc = {}

-- Checks whether a point is inside a rectangle
function Misc.isInsideRect(p_x,p_y,r_x,r_y,r_w,r_h)
    return p_x >= r_x and p_x <= r_x + r_w
    and p_y >= r_y and p_y <= r_y + r_h
end

return Misc