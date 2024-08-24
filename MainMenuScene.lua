local Scene = require("Scene")
local Button = require("Button")
local Slider = require("Slider")
local Image = require("Image")
local Text = require("Text")
local Transition = require("Transition")
local GameScene = require("GameScene")

MainMenuScene = {}
MainMenuScene.__index = MainMenuScene

setmetatable(MainMenuScene, {__index = Scene})

local transition

function MainMenuScene:new()
    local mainMenuScene = Scene:new()
    setmetatable(mainMenuScene, MainMenuScene)

    local font = love.graphics.newFont("Fonts/Roboto-Black.ttf")

    local myImage = Image:new("Sprites/BackdropMain.png", 0, 0)
    myImage:fitToScreen()
    mainMenuScene:addObject(myImage)

    -- Create a Button with the Text object
    local startButton = Button:new(0, 0, 200, 50, "Play", font, 32, OpenGameScene, 10, 10, 0.5, 0.5, 0.5, 0.5)
    mainMenuScene:addObject(startButton)

    local SoundSlider = Slider:new(0, 100, 300, 20, 0, 100, 50, UpdateSound, 0.5, 0.5, 0.5, 0.5) 
    mainMenuScene:addObject(SoundSlider)

    local TitleText = Text:new("Jetpack Joyride", 0, -100, font, 32, 100, 100, true, 0.5, 0.5, 0.5, 0.5)
    mainMenuScene:addObject(TitleText)

    transition = Transition:new(1, ShaderManager:getShader("transitionShader"), TextureManager:getTexture("white"), TextureManager:getTexture("cool"))
    mainMenuScene:addObject(transition)
    
    return mainMenuScene
end

function OpenGameScene()
    -- Start the transition with a callback that changes the scene after the transition completes
    transition:start(function()
        currentScene = GameScene:new()  -- Switch to the GameScene when the transition completes
    end)
end

function UpdateSound(value)

end

return MainMenuScene
