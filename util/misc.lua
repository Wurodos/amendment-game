local Misc = {}

-- Checks whether a point is inside a rectangle
function Misc.isInsideRect(p_x,p_y,r_x,r_y,r_w,r_h)
    return p_x >= r_x and p_x <= r_x + r_w
    and p_y >= r_y and p_y <= r_y + r_h
end


-- Also returns whether something was filtered
function Misc.filter_inplace(arr, func)
    local new_index = 1
    local size_orig = #arr
    local was_filtered = false
    for old_index, v in ipairs(arr) do
        if func(v, old_index) then
            arr[new_index] = v
            new_index = new_index + 1
        else was_filtered = true end
    end
    for i = new_index, size_orig do arr[i] = nil end
    return was_filtered
end


return Misc