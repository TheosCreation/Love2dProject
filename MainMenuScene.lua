local Scene = require("Scene")
local Button = require("Button")
local Slider = require("Slider")
local Image = require("Image")
local Text = require("Text")
local GameScene = require("GameScene")

MainMenuScene = {}
MainMenuScene.__index = MainMenuScene

setmetatable(MainMenuScene, {__index = Scene})

function MainMenuScene:new()
    local mainMenuScene = Scene:new()
    setmetatable(mainMenuScene, MainMenuScene)

    local font = love.graphics.newFont("Fonts/Roboto-Black.ttf")

    local myImage = Image:new("Sprites/BackdropMain.png", 0, 0, 1920, 1080)
    mainMenuScene:addObject(myImage)

    -- Create a Button with the Text object
    local startButton = Button:new(100, 100, 200, 50, "Play", font, 64, OpenGameScene, 10)
    mainMenuScene:addObject(startButton)

    local SoundSlider = Slider:new(100, 200, 300, 20, 0, 100, 50, UpdateSound) 
    mainMenuScene:addObject(SoundSlider)

    local TitleText = Text:new("Jetpack Joyride", 100, 300, font, 32, 100, 100, true)
    mainMenuScene:addObject(TitleText)

    return mainMenuScene
end

function OpenGameScene()
    currentScene = GameScene:new()  -- Switch to the GameScene when clicked
end

function UpdateSound(value)

end

return MainMenuScene
