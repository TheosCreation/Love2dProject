local Scene = require("Scene")
local Button = require("Button")
local Slider = require("Slider")
local Image = require("Image")
local Text = require("Text")
local Transition = require("Transition")
local GameScene = require("GameScene")

GameOverScene = {}
GameOverScene.__index = GameOverScene

setmetatable(GameOverScene, {__index = Scene})

local transition

function GameOverScene:new(distanceTravelled)
    local gameOverScene = Scene:new()
    setmetatable(gameOverScene, GameOverScene)

    local myImage = Image:new("Sprites/menubackground.png", 0, 0)
    myImage:fitToScreen()
    gameOverScene:addObject(myImage)

    -- Create a Button with the Text object
    local startButton = Button:new(0, -125, 200, 50, "Play Again", "Fonts/Roboto-Black.ttf", 32, self.OpenGameScene, 10, 10, 0.5, 0.5, 0.5, 0.5)
    gameOverScene:addObject(startButton)
    
    local startButton = Button:new(0, 125, 200, 50, "Exit To Main Menu", "Fonts/Roboto-Black.ttf", 32, self.OpenMainMenu, 10, 10, 0.5, 0.5, 0.5, 0.5)
    gameOverScene:addObject(startButton)
    
    --new text for the title new(text, x, y, font, fontSize, width, height, wrap, pivotX, pivotY, anchorX, anchorY)
    local TitleText = Text:new("Game Over", 0, -375, "Fonts/Roboto-Black.ttf", 32, 100, 100, true, 0.5, 0.5, 0.5, 0.5)
    TitleText:setColor({0,0,0,1})
    gameOverScene:addObject(TitleText)

    local DistanceTravelledText = Text:new("Distance Travelled: " .. math.floor(distanceTravelled), 0, -325, "Fonts/Roboto-Black.ttf", 32, 100, 100, true, 0.5, 0.5, 0.5, 0.5)
    DistanceTravelledText:setColor({0,0,0,1})
    gameOverScene:addObject(DistanceTravelledText)

    transition = Transition:new(0.2, ShaderManager:getShader("transitionShader"), TextureManager:getTexture("white"), TextureManager:getTexture("cool"))
    gameOverScene:addObject(transition)
    
    return gameOverScene
end

function GameOverScene:OpenGameScene()
    -- Start the transition with a callback that changes the scene after the transition completes
    transition:start(function()
        currentScene = GameScene:new()  -- Switch to the GameScene when the transition completes
    end)
end

function GameOverScene:OpenMainMenu()
    -- Start the transition with a callback that changes the scene after the transition completes
    transition:start(function()
        currentScene = MainMenuScene:new()  -- Switch to the GameScene when the transition completes
    end)
end

function GameOverScene:UpdateTransitionDuration(value)
    transition.duration = value
end

return GameOverScene
