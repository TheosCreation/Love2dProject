local obstacles = {}

local scrWidth, scrHeight

local spawnXOffset = 500
local obstacleWidth = 60

function obstacles.init(screenWidth, screenHeight)
    scrWidth = screenWidth
    scrHeight = screenHeight
end

local obstacleList = {}

local patterns = {}

patterns[1] = function(spawnX)
    local spacing = 750
 
    local angles = {0, -45, 45}
    local lengths = {160, 240, 320}

    for i = 1, 5 do
        -- Choose a random angle from the list
        local randomAngle = angles[math.random(1, #angles)]

        -- Choose a random length from the list
        local randomLength = lengths[math.random(1, #lengths)]    

        obstacles.spawn(spawnX + i * spacing, math.random(randomLength / 2, scrHeight - randomLength / 2), randomLength, randomAngle, 0)
    end
end

patterns[2] = function(spawnX)
    local length = 800
    local gap = 100  -- Gap between the top and bottom obstacles

    -- Spawn one obstacle at the top
    obstacles.spawn(spawnX, gap + obstacleWidth / 2, length, 90, 0)  -- Adjust position by length/2 for centering

    -- Spawn one obstacle at the bottom
    obstacles.spawn(spawnX, scrHeight - (gap + obstacleWidth / 2), length, 90, 0) 
end

function obstacles.spawn(x, y, length, angleDeg, rotationDirection)
    local angle = angleDeg * math.pi / 180 
    -- Create the obstacle with provide properties
    local obstacle = {
        angle = angle,
        height = length,
        width = obstacleWidth,
        x = x + spawnXOffset,
        y = y,
        rotationDirection = rotationDirection
    }
    
    table.insert(obstacleList, obstacle)
end

function obstacles.spawnPattern(spawnX)
    local patternType = math.random(1, #patterns)
    patterns[patternType](spawnX)
end

function obstacles.update(dt, cameraX)
    for i = #obstacleList, 1, -1 do
        local obs = obstacleList[i]

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