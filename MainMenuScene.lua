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

    canTransition = true

    -- Background Image new(image, anchorX, anchorY, width, height, x, y)
    local myImage = Image:new(TextureManager:getTexture("white"), 0, 0)
    myImage:setColor(uiBackgroundColor)
    myImage:stretchToScreen()
    mainMenuScene:addObject(myImage)

    local knightImage = Image:new(TextureManager:getTexture("jetpackKnight"), 0, 0, 1109, 1109, 19, -15)
    mainMenuScene:addObject(knightImage)

    -- Title Text          new(text, x, y, font, fontSize, width, height, wrap, pivotX, pivotY, anchorX, anchorY)
    local TitleText = Text:new("Jetpack Knight", 1112, 113, "Fonts/VCR_OSD_MONO_1.001.ttf", 150, 1232, 113, false, 0, 0, 0, 0)
    TitleText:setColor(white)
    mainMenuScene:addObject(TitleText)

    local HowToStartText = Text:new("Tap anywhere to play", 1250, 485, "Fonts/VCR_OSD_MONO_1.001.ttf", 96, 955, 110, true, 0, 0, 0, 0)
    HowToStartText:setColor(white)
    mainMenuScene:addObject(HowToStartText)

    -- How To Play Button          new(x, y, width, height, text, font, fontSize, onClick, radiusX, radiusY, pivotX, pivotY, anchorX, anchorY)
    local howToPlayButton = Button:new(1528, 874, 400, 125, "How To Play", "Fonts/VCR_OSD_MONO_1.001.ttf", 36, self.OpenHowToPlayScene, 10, 10, 0, 0)
    howToPlayButton:setColor(white)
    howToPlayButton:setTextColor({0,0,0,1})
    mainMenuScene:addObject(howToPlayButton)

    -- Sound Slider
    --local SoundSlider = Slider:new(400, 400, 300, 20, 0, 1, 0.5, self.UpdateTransitionDuration, 0.5, 0.5, 0.5, 0.5)
    --mainMenuScene:addObject(SoundSlider)

    -- Transition
    transition = Transition:new(0.2, ShaderManager:getShader("transitionShader"), TextureManager:getTexture("white"), TextureManager:getTexture("cool"))
    mainMenuScene:addObject(transition)
    
    return mainMenuScene
end

function MainMenuScene:mousepressed(x, y, button)
    self.OpenGameScene()
    Scene.mousepressed(self, x, y, button)
end

function MainMenuScene:OpenGameScene()
    if(canTransition) then
        transition:start(function()
            currentScene = GameScene:new()
        end)
    canTransition = false
    end
end

function MainMenuScene:OpenHowToPlayScene()  
    if(canTransition) then
        transition:start(function()
            currentScene = HowToPlayScene:new()
        end)
    canTransition = false
    end
end

--function MainMenuScene:UpdateTransitionDuration(value)
--    transition.duration = value
--end

return MainMenuScene