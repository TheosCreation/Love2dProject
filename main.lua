local time = 0
local fpsHistory = {}
local maxFPSHistory = 1000
local framerate = 0

local distanceTraveled = 0
local distanceDivisionFactor = 60

local scrWidth, scrHeight
local gravity = 1100
local jetpackForce = -2500
local maxSpeedJetpack = -1000

local groundAndRoofSpacing = 80
local playerSpeed = 600
local speedIncrement = 2

-- Require the Camera, Obstacles, and Character modules
local Camera = require("camera")
local Obstacles = require("obstacles")
local Character = require("character")

local mousePosX = 0
local mousePosY = 0

-- Background image variables
local background
local backgroundWidth
local backgroundHeight
local backgroundScroll = 0
local backgroundScaleX
local backgroundScaleY

-- Initialize character
local character

function love.load()
    math.randomseed(os.time())

    scrWidth = love.graphics.getWidth()
    scrHeight = love.graphics.getHeight()

    love.graphics.setNewFont(24)

    -- Load background image
    background = love.graphics.newImage("Sprites/backgroundLoop.png")
    backgroundWidth, backgroundHeight = background:getDimensions()

    -- Calculate scaling factors to fit the screen height
    backgroundScaleY = scrHeight / backgroundHeight
    backgroundScaleX = backgroundScaleY -- Maintain aspect ratio

    -- Initialize camera
    camera = Camera
    camera:setPosition(scrWidth / 2.5, 0)

    -- Initialize obstacles
    Obstacles.init(scrWidth, scrHeight, groundAndRoofSpacing)

    -- Create a new character instance
    local playerSize = 100
    local startY = (scrHeight - groundAndRoofSpacing) - playerSize / 2
    character = Character:new(100, startY, playerSize, playerSize, "Sprites/CharacterIdle.png")
end

function love.draw()
    love.graphics.clear(0.5, 0.8, 1)

    love.graphics.setColor(1, 1, 1)
    -- Draw scrolling background with scaling
    local totalWidth = backgroundWidth * backgroundScaleX
    local numTiles = math.ceil(scrWidth / totalWidth) + 1

    for i = 0, numTiles do
        love.graphics.draw(
            background,
            i * totalWidth - (backgroundScroll % totalWidth),
            0,
            0,
            backgroundScaleX,
            backgroundScaleY
        )
    end

    camera:set()

    -- Draw character
    character:draw()

    -- Draw obstacles
    Obstacles.draw()

    camera:unset()

    -- UI
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf("Time: " .. math.floor(time), 5, 0, scrWidth, "left")
    love.graphics.printf("FPS: " .. math.floor(framerate), 5, 30, scrWidth, "left")
    love.graphics.printf("Distance: " .. math.floor(distanceTraveled), 5, 60, scrWidth, "left")
    love.graphics.printf("Speed: " .. math.floor(playerSpeed), 5, 90, scrWidth, "left")
end

function love.update(dt)
    local fps = 1 / dt
    table.insert(fpsHistory, fps)
    if #fpsHistory > maxFPSHistory then
        table.remove(fpsHistory, 1)
    end
    local sum = 0
    for _, v in ipairs(fpsHistory) do
        sum = sum + v
    end
    framerate = sum / #fpsHistory
    time = time + dt

    -- Gradually increase player speed
    playerSpeed = playerSpeed + speedIncrement * dt

    -- Update distance traveled
    distanceTraveled = distanceTraveled + (playerSpeed / distanceDivisionFactor) * dt

    -- Update background scroll position
    backgroundScroll = backgroundScroll + playerSpeed * dt

    -- Update character
    character:update(dt, gravity, jetpackForce, maxSpeedJetpack)
    character.x = character.x + playerSpeed * dt

    -- Collision with ground and ceiling
    local _, charY = character:getPosition()
    if charY > (scrHeight - groundAndRoofSpacing) - character.height / 2 then
        character.y = (scrHeight - groundAndRoofSpacing) - character.height / 2
        character.velocityY = 0
    elseif charY < groundAndRoofSpacing + character.height / 2 then
        character.y = groundAndRoofSpacing + character.height / 2
        character.velocityY = 0
    end

    -- Update camera position (only horizontally)
    camera:setPosition(character.x - scrWidth / 2.5, 0)

    -- Update obstacles
    Obstacles.update(dt, camera:getPositionX())

    -- Check if there are no obstacles
    if Obstacles.isEmpty() then
        Obstacles.spawnPattern(camera:getPositionX() + scrWidth)
    end

    -- Check collision with character
    if Obstacles.checkCollision(character) then
        -- open game over scene
        love.event.quit()
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then
        -- LMB
        character:setFlying(true)
    end
end

function love.mousereleased(x, y, button)
    if button == 1 then
        -- LMB
        character:setFlying(false)
        mousePosX = x
        mousePosY = y
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
