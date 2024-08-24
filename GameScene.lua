local Scene = require("Scene")
local Camera = require("camera")
local Obstacles = require("obstacles")
local Character = require("character")
local Text = require("Text")

GameScene = {}
GameScene.__index = GameScene

setmetatable(GameScene, {__index = Scene})

function GameScene:new()
    local gameScene = Scene:new()
    setmetatable(gameScene, GameScene)

    -- Initialize game-specific variables
    gameScene.time = 0
    gameScene.fpsHistory = {}
    gameScene.maxFPSHistory = 1000
    gameScene.framerate = 0
    gameScene.distanceTraveled = 0
    gameScene.distanceDivisionFactor = 60

    gameScene.scrWidth = love.graphics.getWidth()
    gameScene.scrHeight = love.graphics.getHeight()
    gameScene.gravity = 1250
    gameScene.jetpackForce = -3000
    gameScene.maxSpeedJetpack = -600
    gameScene.groundAndRoofSpacing = 80
    gameScene.playerSpeed = 600
    gameScene.speedIncrement = 2

    -- Load background image
    gameScene.background = love.graphics.newImage("Sprites/backgroundLoop.png")
    gameScene.backgroundWidth, gameScene.backgroundHeight = gameScene.background:getDimensions()
    gameScene.backgroundScroll = 0
    gameScene.backgroundScaleY = gameScene.scrHeight / gameScene.backgroundHeight
    gameScene.backgroundScaleX = gameScene.backgroundScaleY

    -- Initialize camera
    gameScene.camera = Camera
    gameScene.camera:setPosition(gameScene.scrWidth / 2.5, 0)

    -- Initialize obstacles
    Obstacles.init(gameScene.scrWidth, gameScene.scrHeight, gameScene.groundAndRoofSpacing)

    local sawbladeIdle = Animation:new(love.graphics.newImage("Sprites/sawblade.png"), 64, 32, 0.5)
    Obstacles.addAnimation("idle", sawbladeIdle)
    Obstacles.setAnimation("idle")

    -- Create a new player instance
    local playerSize = 100
    local startY = (gameScene.scrHeight - gameScene.groundAndRoofSpacing) - playerSize / 2
    gameScene.character = Character:new(100, startY, playerSize, playerSize)

    -- Create animations for the player
    local flyingAnimation = Animation:new(love.graphics.newImage("Sprites/flying_spritesheet.png"), 64, 64, 2)
    gameScene.character:addAnimation("flying", flyingAnimation)

    local walkingAnimations = Animation:new(love.graphics.newImage("Sprites/walking_spritesheet.png"), 64, 64, 0.5)
    gameScene.character:addAnimation("walking", walkingAnimations)

    -- Set the inital animation state
    gameScene.character:setAnimation("walking")

    -- Initialize debug text
    gameScene.timeText = Text:new("Time: 0", 5, 0, "Fonts/Roboto-Black.ttf", 20, gameScene.scrWidth, 30, false)
    gameScene.fpsText = Text:new("FPS: 0", 5, 30, "Fonts/Roboto-Black.ttf", 20, gameScene.scrWidth, 30, false)
    gameScene.distanceText = Text:new("Distance: 0", 5, 60, "Fonts/Roboto-Black.ttf", 20, gameScene.scrWidth, 30, false)
    gameScene.speedText = Text:new("Speed: 0", 5, 90, "Fonts/Roboto-Black.ttf", 20, gameScene.scrWidth, 30, false)

    return gameScene
end

function GameScene:update(dt)
    Scene.update(self, dt) -- Update all objects in the scene

    local fps = 1 / dt
    table.insert(self.fpsHistory, fps)
    if #self.fpsHistory > self.maxFPSHistory then
        table.remove(self.fpsHistory, 1)
    end

    local sum = 0
    for _, v in ipairs(self.fpsHistory) do
        sum = sum + v
    end
    self.framerate = sum / #self.fpsHistory
    self.time = self.time + dt

    -- Gradually increase player speed
    self.playerSpeed = self.playerSpeed + self.speedIncrement * dt

    -- Update distance traveled
    self.distanceTraveled = self.distanceTraveled + (self.playerSpeed / self.distanceDivisionFactor) * dt

    -- Update background scroll position
    self.backgroundScroll = self.backgroundScroll + self.playerSpeed * dt

    -- Update character
    self.character:update(dt, self.gravity, self.jetpackForce, self.maxSpeedJetpack)
    self.character.x = self.character.x + self.playerSpeed * dt

    -- Collision with ground and ceiling
    local _, charY = self.character:getPosition()
    if charY > (self.scrHeight - self.groundAndRoofSpacing) - self.character.height / 2 then
        self.character.y = (self.scrHeight - self.groundAndRoofSpacing) - self.character.height / 2
        self.character.velocityY = 0
        self.character:setAnimation("walking")
    elseif charY < self.groundAndRoofSpacing + self.character.height / 2 then
        self.character.y = self.groundAndRoofSpacing + self.character.height / 2
        self.character.velocityY = 0
    end

    -- Update camera position (only horizontally)
    self.camera:setPosition(self.character.x - self.scrWidth / 2.5, 0)

    -- Update obstacles
    Obstacles.update(dt, self.camera:getPositionX())

    -- Check if there are no obstacles
    if Obstacles.isEmpty() then
        Obstacles.spawnPattern(self.camera:getPositionX() + self.scrWidth)
    end

    -- Check collision with character
    if Obstacles.checkCollision(self.character) then
        currentScene = MainMenuScene:new()
    end

    -- Update debug text
    self.timeText:setText("Time: " .. math.floor(self.time))
    self.fpsText:setText("FPS: " .. math.floor(self.framerate))
    self.distanceText:setText("Distance: " .. math.floor(self.distanceTraveled))
    self.speedText:setText("Speed: " .. math.floor(self.playerSpeed))
end

function GameScene:draw()
    love.graphics.clear(0.5, 0.8, 1)

    love.graphics.setColor(1, 1, 1)

    local myShader = ShaderManager:getShader("myShader")
    love.graphics.setShader(myShader)

    -- Draw scrolling background with scaling
    local totalWidth = self.backgroundWidth * self.backgroundScaleX
    local numTiles = math.ceil(self.scrWidth / totalWidth) + 1

    for i = 0, numTiles do
        love.graphics.draw(
            self.background,
            i * totalWidth - (self.backgroundScroll % totalWidth),
            0,
            0,
            self.backgroundScaleX,
            self.backgroundScaleY
        )
    end

    self.camera:set()

    -- Draw character
    self.character:draw()

    -- Draw obstacles
    Obstacles.draw()

    self.camera:unset()

    -- Draw UI texts
    self.timeText:draw()
    self.fpsText:draw()
    self.distanceText:draw()
    self.speedText:draw()

    Scene.draw(self) -- Draw all objects in the scene

    love.graphics.setShader()
end

function GameScene:mousepressed(x, y, button)
    if button == 1 then
        -- LMB
        self.character:setFlying(true)
        self.character:setAnimation("flying")
    end
end

function GameScene:mousereleased(x, y, button)
    if button == 1 then
        -- LMB
        self.character:setFlying(false)
    end
end

return GameScene