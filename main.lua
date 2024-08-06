local time = 0
local framerate = 0

local scrWidth, scrHeight
local gravity = 1100
local jetpackForce = -2500
local maxSpeedJetpack = -1000
local character = {
    x = 100,
    y = 200,
    width = 100,
    height = 100,
    velocityY = 0, 
    isFlying = false,
    angle = 0          
}

local playerSpeed = 350
local speedIncrement = 10

-- Require the Camera and Obstacles modules
local Camera = require("camera")
local Obstacles = require("obstacles")

local mousePosX = 0
local mousePosY = 0

function love.load()
    math.randomseed(os.time())

    scrWidth = love.graphics.getWidth()
    scrHeight = love.graphics.getHeight()
    
    love.graphics.setNewFont(24)
    
    -- Initialize camera
    camera = Camera
    camera:setPosition(character.x - scrWidth / 2.5, 0)
    
    -- Initialize obstacles
    Obstacles.init(scrWidth, scrHeight)
end

function love.draw()
    love.graphics.clear(0.5, 0.8, 1)

    camera:set()

    -- Draw character
    love.graphics.setColor(1, 0, 0)

    love.graphics.push()
    love.graphics.translate(character.x, character.y)
    love.graphics.rectangle("fill", -character.width/2, -character.height/2, character.width, character.height)
    love.graphics.pop()

    -- Draw obstacles
    Obstacles.draw()

    camera:unset()

    -- UI
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Time: " .. math.floor(time), 5, 0, love.graphics.getWidth(), "left")
    love.graphics.printf("FPS: " .. framerate, 5, 30, love.graphics.getWidth(), "left")
end

function love.update(dt)
    framerate = math.floor(1 / dt)
    time = time + dt

    -- Gradually increase player speed
    playerSpeed = playerSpeed + speedIncrement * dt

    -- Update character
    if character.isFlying then
        character.velocityY = character.velocityY + jetpackForce * dt
    else
        character.velocityY = character.velocityY + gravity * dt
    end

    if character.velocityY < maxSpeedJetpack then
        character.velocityY = maxSpeedJetpack
    end

    character.y = character.y + character.velocityY * dt
    character.x = character.x + playerSpeed * dt  -- Move the character forward

    -- Collision with ground and ceiling
    if character.y > scrHeight - character.height / 2 then
        character.y = scrHeight - character.height / 2
        character.velocityY = 0
    elseif character.y < character.height / 2 then
        character.y = character.height / 2
        character.velocityY = 0
    end

    -- Update camera position (only horizontally)
    camera:setPosition(character.x - scrWidth / 2.5, 0)

    -- Update obstacles
    Obstacles.update(dt, camera:getPositionX())

    -- Check if there is no obstacles
    if Obstacles.isEmpty() then
        Obstacles.spawnPattern(camera:getPositionX() + scrWidth)
    end

    -- Check collision with character
    if Obstacles.checkCollision(character) then
        --open gameoverscene
        love.event.quit()
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then
        -- LMB
        character.isFlying = true
    elseif button == 2 then
        -- RMB
    elseif button == 3 then
        -- MMB
    end
end

function love.mousereleased(x, y, button)
    if button == 1 then
        -- LMB
        character.isFlying = false
        mousePosX = x
        mousePosY = y
    elseif button == 2 then
        -- RMB
    elseif button == 3 then
        -- MMB
    end
end

-- Function to project a rectangle on an axis
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