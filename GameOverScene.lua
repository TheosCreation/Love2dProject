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
    canTransition = true
    -- Background Image new(image, anchorX, anchorY, width, height, x, y)
    local myImage = Image:new(TextureManager:getTexture("white"), 0, 0)
    myImage:setColor(uiBackgroundColor)
    myImage:stretchToScreen()
    gameOverScene:addObject(myImage)

    -- Title Text          new(text, x, y, font, fontSize, width, height, wrap, pivotX, pivotY, anchorX, anchorY)
    local TitleText = Text:new("You Flew", 512, 370, "Fonts/VCR_OSD_MONO_1.001.ttf", 96, 1232, 113, false, 0, 0, 0, 0)
    TitleText:setColor(white)
    gameOverScene:addObject(TitleText)
    
    local DistanceTravelledText = Text:new(math.floor(distanceTravelled) .. "M", 512, 483, "Fonts/VCR_OSD_MONO_1.001.ttf", 150, 1232, 113, false, 0, 0, 0, 0)
    DistanceTravelledText:setColor(white)
    gameOverScene:addObject(DistanceTravelledText)

    -- Next Button         new(x, y, width, height, text, font, fontSize, onClick, radiusX, radiusY, pivotX, pivotY, anchorX, anchorY)
    local nextButton = Button:new(928, 900, 400, 125, "Next", "Fonts/VCR_OSD_MONO_1.001.ttf", 36, self.OpenMainMenu, 10, 10, 0, 0)
    nextButton:setColor(white)
    nextButton:setTextColor({0,0,0,1})
    gameOverScene:addObject(nextButton)

    transition = Transition:new(0.2, ShaderManager:getShader("transitionShader"), TextureManager:getTexture("white"), TextureManager:getTexture("cool"))
    gameOverScene:addObject(transition)
    
    return gameOverScene
end

function GameOverScene:OpenMainMenu()
    if(canTransition) then
        transition:start(function()
            currentScene = MainMenuScene:new()
        end)
    canTransition = false
    end
end

function GameOverScene:UpdateTransitionDuration(value)
    transition.duration = value
end

return GameOverScene
