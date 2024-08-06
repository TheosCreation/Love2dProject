local obstacles = {}

local scrWidth, scrHeight, grSpacing

local spawnXOffset = 500
local obstacleWidth = 60

function obstacles.init(screenWidth, screenHeight, groundAndRoofSpacing)
    scrWidth = screenWidth
    scrHeight = screenHeight
    grSpacing = groundAndRoofSpacing
end

local obstacleList = {}

local patterns = {}

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
        local spacing = 800
        local angles = {0, -45, 45}
        local lengths = {160, 240, 320}
        local chanceOfRotation = 0.2

        for i = 1, 3 do
            local randomAngle = angles[math.random(1, #angles)]
            local randomLength = lengths[math.random(1, #lengths)]
            local rotationDirection = getRotationDirection(chanceOfRotation)
            local rotationSpeed = math.random() * 2

            obstacles.spawn(spawnX + i * spacing, math.random(grSpacing + randomLength / 2, (scrHeight - grSpacing) - randomLength / 2), randomLength, randomAngle, rotationDirection * rotationSpeed)
        end
    end, weight = 3},

    {pattern = function(spawnX)
        local spacing = 750
        local angles = {0, -45, 45}
        local lengths = {160, 240, 320}
        local chanceOfRotation = 0.2

        for i = 1, 8 do
            local randomAngle = angles[math.random(1, #angles)]
            local randomLength = lengths[math.random(1, #lengths)]
            local rotationDirection = getRotationDirection(chanceOfRotation)
            local rotationSpeed = math.random() * 2

            obstacles.spawn(spawnX + i * spacing, math.random(grSpacing + randomLength / 2, (scrHeight - grSpacing) - randomLength / 2), randomLength, randomAngle, rotationDirection * rotationSpeed)
        end
    end, weight = 3},

    {pattern = function(spawnX)
        local spacing = 750
        local angles = {0, -45, 45}
        local lengths = {160, 240, 320}
        local chanceOfRotation = 0.2

        for i = 1, 15 do
            local randomAngle = angles[math.random(1, #angles)]
            local randomLength = lengths[math.random(1, #lengths)]
            local rotationDirection = getRotationDirection(chanceOfRotation)
            local rotationSpeed = math.random() * 2

            obstacles.spawn(spawnX + i * spacing, math.random(grSpacing + randomLength / 2, (scrHeight - grSpacing) - randomLength / 2), randomLength, randomAngle, rotationDirection * rotationSpeed)
        end
    end, weight = 2},

    {pattern = function(spawnX)
        local length = 1000
        local gap = 100

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
    -- Create the obstacle with provide properties
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
    love.graphics.setColor(0, 0, 0)
    for _, obs in ipairs(obstacleList) do
        love.graphics.push()
        love.graphics.translate(obs.x, obs.y)
        love.graphics.rotate(obs.angle)
        love.graphics.rectangle("fill", -obs.width/2, -obs.height/2, obs.width, obs.height)
        love.graphics.pop()
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

return obstacles