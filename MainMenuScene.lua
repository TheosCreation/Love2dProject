local Scene = require("Scene")
local Button = require("Button")
local Slider = require("Slider")
local Image = require("Image")
local Text = require("Text")
local Transition = require("Transition")

MainMenuScene = {}
MainMenuScene.__index = MainMenuScene

setmetatable(MainMenuScene, {__index = Scene})

local transition

function MainMenuScene:new()
    local mainMenuScene = Scene:new()
    setmetatable(mainMenuScene, MainMenuScene)

    local myImage = Image:new("Sprites/menubackground.png", 0, 0)
    myImage:fitToScreen()
    mainMenuScene:addObject(myImage)

    -- Create a Button with the Text object 
    local startButton = Button:new(0, 0, 200, 50, "Play", "Fonts/Roboto-Black.ttf", 32, self.OpenGameScene, 10, 10, 0.5, 0.5, 0.5, 0.5)
    mainMenuScene:addObject(startButton)

    local SoundSlider = Slider:new(0, 100, 300, 20, 0, 1, 0.5, self.UpdateTransitionDuration, 0.5, 0.5, 0.5, 0.5) 
    mainMenuScene:addObject(SoundSlider)

    --new text for the title new(text, x, y, font, fontSize, width, height, wrap, pivotX, pivotY, anchorX, anchorY)
    local TitleText = Text:new("Jetpack Joyride", 0, -100, "Fonts/Roboto-Black.ttf", 32, 100, 100, true, 0.5, 0.5, 0.5, 0.5)
    TitleText:setColor({0,0,0,1})
    mainMenuScene:addObject(TitleText)

    transition = Transition:new(0.2, ShaderManager:getShader("transitionShader"), TextureManager:getTexture("white"), TextureManager:getTexture("cool"))
    mainMenuScene:addObject(transition)
    
    return mainMenuScene
end

function MainMenuScene:OpenGameScene()
    -- Start the transition with a callback that changes the scene after the transition completes
    transition:start(function()
        currentScene = GameScene:new()  -- Switch to the GameScene when the transition completes
    end)
end

function MainMenuScene:UpdateTransitionDuration(value)
    transition.duration = value
end

return MainMenuScene
