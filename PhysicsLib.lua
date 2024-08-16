PhysicsLib = {}

function PhysicsLib.CheckOBBCollision(rectA, rectB)
    local axes = {
        {x = math.cos(rectA.angle), y = math.sin(rectA.angle)},
        {x = -math.sin(rectA.angle), y = math.cos(rectA.angle)},
        {x = math.cos(rectB.angle), y = math.sin(rectB.angle)},
        {x = -math.sin(rectB.angle), y = math.cos(rectB.angle)}
    }

    for _, axis in ipairs(axes) do
        local minA, maxA = projectRect(rectA, axis)
        local minB, maxB = projectRect(rectB, axis)

        if not overlap(minA, maxA, minB, maxB) then
            return false
        end
    end

    return true
end

local function projectRect(rect, axis)
    local halfWidth = rect.width / 2
    local halfHeight = rect.height / 2
    local corners = {
        {x = rect.x - halfWidth, y = rect.y - halfHeight},
        {x = rect.x + halfWidth, y = rect.y - halfHeight},
        {x = rect.x + halfWidth, y = rect.y + halfHeight},
        {x = rect.x - halfWidth, y = rect.y + halfHeight}
    }

    local cosA = math.cos(rect.angle)
    local sinA = math.sin(rect.angle)

    for i, corner in ipairs(corners) do
        local x = corner.x - rect.x
        local y = corner.y - rect.y
        corners[i].x = x * cosA - y * sinA + rect.x
        corners[i].y = x * sinA + y * cosA + rect.y
    end

    local min, max = nil, nil

    for _, corner in ipairs(corners) do
        local dot = corner.x * axis.x + corner.y * axis.y
        if not min or dot < min then
            min = dot
        end
        if not max or dot > max then
            max = dot
        end
    end

    return min, max
end

local function overlap(minA, maxA, minB, maxB)
return maxA >= minB and maxB >= minA
end

return PhysicsLib