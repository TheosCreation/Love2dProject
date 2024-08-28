local obstacles = {}


local spawnXOffset = 500
local obstacleWidthRatio = 0.05 -- Ratio of obstacle width to screen width

function obstacles.init(screenWidth, screenHeight, groundAndRoofSpacing, _sprite)
    scrWidth = screenWidth
    scrHeight = screenHeight
    grSpacing = groundAndRoofSpacing
    sprite = _sprite
    obstacleWidth = scrWidth * obstacleWidthRatio -- Scale the obstacle width based on the screen width
end

local obstacleList = {}



local patterns = {}

function obstacles.reset()
    obstacleList = {}
end

-- Function to determine rotation direction based on chance
local function getRotationDirection(chanceOfRotation)
    if math.random() < chanceOfRotation then
        -- Randomly choose between -1 and 1 for rotation
        return math.random(0, 1) * 2 - 1
    else
        -- No rotation
        return 0
    end
end

local patternWeights = {
    {pattern = function(spawnX)
        local spacing = 0.75 * scrWidth -- Scale spacing based on screen width
        local angles = {0, -45, 45}
        local lengths = {scrHeight * 0.15, scrHeight * 0.25, scrHeight * 0.35} -- Scale lengths based on screen height
        local chanceOfRotation = 0.2

        for i = 1, 8 do
            local randomAngle = angles[math.random(1, #angles)]
            local randomLength = lengths[math.random(1, #lengths)]
            local rotationDirection = getRotationDirection(chanceOfRotation)
            local rotationSpeed = math.random() * 2

            obstacles.spawn(spawnX + i * spacing, math.random(grSpacing + randomLength / 2, (scrHeight - grSpacing / 2) - randomLength / 2), randomLength, randomAngle, rotationDirection * rotationSpeed)
        end
    end, weight = 3},

    {pattern = function(spawnX)
        local spacing = 0.75 * scrWidth -- Scale spacing based on screen width
        local angles = {0, -45, 45}
        local lengths = {scrHeight * 0.15, scrHeight * 0.25, scrHeight * 0.35} -- Scale lengths based on screen height
        local chanceOfRotation = 0.2

        for i = 1, 15 do
            local randomAngle = angles[math.random(1, #angles)]
            local randomLength = lengths[math.random(1, #lengths)]
            local rotationDirection = getRotationDirection(chanceOfRotation)
            local rotationSpeed = math.random() * 2

            obstacles.spawn(spawnX + i * spacing, math.random(grSpacing + randomLength / 2, (scrHeight - grSpacing / 2) - randomLength / 2), randomLength, randomAngle, rotationDirection * rotationSpeed)
        end
    end, weight = 2},

    {pattern = function(spawnX)
        local length = scrHeight * 0.8 -- Scale the length based on screen height
        local gap = scrHeight * 0.1 -- Scale the gap based on screen height

        obstacles.spawn(spawnX, gap + obstacleWidth / 2, length, 90, 0)
        obstacles.spawn(spawnX, scrHeight - (gap + obstacleWidth / 2), length, 90, 0)
    end, weight = 1}
}

-- Function to select a pattern based on weights
local function selectPattern()
    local totalWeight = 0
    for _, patternInfo in ipairs(patternWeights) do
        totalWeight = totalWeight + patternInfo.weight
    end

    local randomValue = math.random() * totalWeight
    local cumulativeWeight = 0

    for _, patternInfo in ipairs(patternWeights) do
        cumulativeWeight = cumulativeWeight + patternInfo.weight
        if randomValue <= cumulativeWeight then
            return patternInfo.pattern
        end
    end
end

function obstacles.spawn(x, y, length, angleDeg, rotation)
    local angle = angleDeg * math.pi / 180 
    -- Create the obstacle with provided properties
    local obstacle = {
        angle = angle,
        height = length,
        width = obstacleWidth,
        x = x + spawnXOffset,
        y = y,
        rotation = rotation
    }
    
    table.insert(obstacleList, obstacle)
end

function obstacles.spawnPattern(spawnX)
    local pattern = selectPattern()
    pattern(spawnX)
end

function obstacles.update(dt, cameraX)
    for i = #obstacleList, 1, -1 do
        local obs = obstacleList[i]

        obs.angle = obs.angle + obs.rotation * dt

        -- Mark off-screen obstacles
        if obs.x + spawnXOffset < cameraX then
            table.remove(obstacleList, i)
        end
    end
end

function obstacles.draw()
    love.graphics.setColor(1, 1, 1)  -- Set the color to white (default color for drawing)
    for _, obs in ipairs(obstacleList) do
        love.graphics.push()
        love.graphics.translate(obs.x, obs.y) -- Move to the obstacle's position
        love.graphics.rotate(obs.angle)       -- Rotate the obstacle to its current angle

        -- Draw the sprite at the center of the obstacle with proper scaling
        if sprite then
            local scaleX = obs.width / sprite:getWidth()
            local scaleY = obs.height / sprite:getHeight()
            love.graphics.draw(
                sprite,
                0, 0,                       -- Draw the sprite at (0, 0) of the translated and rotated coordinates
                0,                          -- No additional rotation needed here (already handled by love.graphics.rotate)
                scaleX, scaleY,             -- Scale the sprite to fit the obstacle dimensions
                sprite:getWidth() / 2,      -- Offset by half the sprite's width to center it
                sprite:getHeight() / 2      -- Offset by half the sprite's height to center it
            )
        end

        love.graphics.pop() -- Restore previous graphics state
    end
end

function obstacles.checkCollision(character)
    for _, obs in ipairs(obstacleList) do
        if CheckOBBCollision(character, obs) then
            return true
        end
    end
    return false
end

function obstacles.isEmpty()
    return #obstacleList == 0
end

function CheckOBBCollision(rectA, rectB)
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

function projectRect(rect, axis)
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

function overlap(minA, maxA, minB, maxB)
    return maxA >= minB and maxB >= minA
end

return obstacles
