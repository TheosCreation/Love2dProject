local Scene = require("Scene")
local Button = require("Button")
local Slider = require("Slider")
local Image = require("Image")
local Text = require("Text")
local Transition = require("Transition")

HowToPlayScene = {}
HowToPlayScene.__index = HowToPlayScene

setmetatable(HowToPlayScene, {__index = Scene})

local transition

function HowToPlayScene:new()
    local howToPlayScene = Scene:new()
    setmetatable(howToPlayScene, HowToPlayScene)

    canTransition = true
    
    -- Background Image new(image, anchorX, anchorY, width, height, x, y)
    local myImage = Image:new(TextureManager:getTexture("white"), 0, 0)
    myImage:setColor(uiBackgroundColor)
    myImage:stretchToScreen()
    howToPlayScene:addObject(myImage)
    
    local knightImage = Image:new(TextureManager:getTexture("jetpackKnight"), 0, 0, 174, 174, 1113, 877)
    howToPlayScene:addObject(knightImage)

    -- Title Text          new(text, x, y, font, fontSize, width, height, wrap, pivotX, pivotY, anchorX, anchorY, color)
    local TitleText = Text:new("How To Play", 434, 113, "Fonts/VCR_OSD_MONO_1.001.ttf", 150, 1532, 141, false, 0, 0, 0, 0)
    TitleText:setColor(white)
    howToPlayScene:addObject(TitleText)

    local HowToPlayText = Text:new("Tap anywhere on the screen to fly upward, try to avoid the lasers and get the best high scores", 408, 328, "Fonts/VCR_OSD_MONO_1.001.ttf", 96, 1581, 423, true, 0, 0)
    HowToPlayText:setColor(white)
    howToPlayScene:addObject(HowToPlayText)

    -- Back Button          new(x, y, width, height, text, font, fontSize, onClick, radiusX, radiusY, pivotX, pivotY, anchorX, anchorY)
    local backButton = Button:new(62, 42, 269, 114, "Back", "Fonts/VCR_OSD_MONO_1.001.ttf", 36, self.OpenMainMenuScene, 10, 10, 0, 0)
    backButton:setColor(white)
    backButton:setTextColor({0,0,0,1})
    howToPlayScene:addObject(backButton)

    -- Transition
    transition = Transition:new(0.2, ShaderManager:getShader("transitionShader"), TextureManager:getTexture("white"), TextureManager:getTexture("cool"))
    howToPlayScene:addObject(transition)
    
    return howToPlayScene
end

function HowToPlayScene:OpenMainMenuScene()
    if(canTransition) then
        transition:start(function()
            currentScene = MainMenuScene:new()
        end)
    canTransition = false
    end
end

return HowToPlayScene