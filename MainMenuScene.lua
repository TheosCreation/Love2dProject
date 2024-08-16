local Scene = require("Scene")
local Button = require("Button")
local GameScene = require("GameScene")

MainMenuScene = {}
MainMenuScene.__index = MainMenuScene

setmetatable(MainMenuScene, {__index = Scene})

function MainMenuScene:new()
    local mainMenuScene = Scene:new()
    setmetatable(mainMenuScene, MainMenuScene)

    -- Create and add buttons to the scene
    local button = Button:new(100, 100, 200, 50, "Start Game", OpenGameScene)

    mainMenuScene:addObject(button)
    return mainMenuScene
end

function OpenGameScene()
    currentScene = GameScene:new()  -- Switch to the GameScene when clicked
end

return MainMenuScene
